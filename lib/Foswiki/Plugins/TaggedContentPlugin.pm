package Foswiki::Plugins::TaggedContentPlugin;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Plugins ();

use utf8;

use version;
our $VERSION = version->declare( '1.0.0' );
our $RELEASE = "1.0";

sub initPlugin {
  my ( $topic, $web, $user, $installWeb ) = @_;

  if ( $Foswiki::Plugins::VERSION < 2.0 ) {
      Foswiki::Func::writeWarning( 'Version mismatch between ',
          __PACKAGE__, ' and Plugins.pm' );
      return 0;
  }

  Foswiki::Func::registerTagHandler( 'SETTAGGEDCONTENTPREFS', \&_setTaggedContentPrefs );

  return 1;
}

sub _setTaggedContentPrefs {
  my( $session, $params, $topic, $web, $topicObject ) = @_;

  my $categories = Foswiki::Func::getPreferencesValue("TAGGED_CONTENT_CATEGORIES");
  my @categories = split(/\s*,\s*/, $categories);
  @categories = map("field_".$_."_s", @categories);
  my $solrCategories = join(", ", @categories);

  my $similarTopicsLike = "title_search,$solrCategories";
  my $similarTopicsBoost = "title_search,$solrCategories";
  my $similarTopicsFields = "title,web,topic,field_Responsible_s,score,field_DocumentType_s,date,process_state_s,$solrCategories";
  my $similarTopicsFilter = "web: $web -topic:*TALK";

  Foswiki::Func::setPreferencesValue( "SIMILAR_TOPICS_LIKE", $similarTopicsLike);
  Foswiki::Func::setPreferencesValue( "SIMILAR_TOPICS_BOOST", $similarTopicsBoost );
  Foswiki::Func::setPreferencesValue( "SIMILAR_TOPICS_FIELDS", $similarTopicsFields );
  Foswiki::Func::setPreferencesValue( "SIMILAR_TOPICS_FILTER", $similarTopicsFilter );

  return '';
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: Modell Aachen GmbH <support@modell-aachen.de>

Copyright (C) 2008-2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
