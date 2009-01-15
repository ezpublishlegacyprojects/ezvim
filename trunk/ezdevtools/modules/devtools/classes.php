<?php
//
// Copyright (C) 2006 Smile. All rights reserved.
//               2008 Damien POBEL
// Authors:
//	 Julian Roblin <julian.roblin@smile.fr>
//	 Damien POBEL  <dpobel@free.fr>
//
// This file may be distributed and/or modified under the terms of the
// "GNU General Public License" version 2 as published by the Free
// Software Foundation and appearing in the file LICENSE included in
// the packaging of this file.
//
// Licencees holding a valid "eZ publish professional licence" version 2
// may use this file in accordance with the "eZ publish professional licence"
// version 2 Agreement provided with the Software.
//
// This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING
// THE WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE.
//
// The "eZ publish professional licence" version 2 is available at
// http://ez.no/ez_publish/licences/professional/ and in the file
// PROFESSIONAL_LICENCE included in the packaging of this file.
// For pricing of this licence please contact us via e-mail to licence@ez.no.
// Further contact information is available at http://ez.no/company/contact/.
//
// The "GNU General Public License" (GPL) is available at
// http://www.gnu.org/copyleft/gpl.html.
//
// Contact licence@ez.no if any conditions of this licencing isn't clear to
// you.
//

$devINI = eZINI::instance( 'devtools.ini' );

$groupBlackList = $devINI->variable( 'ClassesExport', 'GroupBlackListID' );
$classBlackList = $devINI->variable( 'ClassesExport', 'ClassBlackListID' );

$groupList = eZContentClassGroup::fetchList();
$dom = new DomDocument( '1.0' );
$root = $dom->createElement( 'contentclasslist' );
$root = $dom->appendChild( $root );
foreach( $groupList as $group )
{
    if ( in_array( $group->attribute( 'id' ), $groupBlackList ) )
    {
        continue;
    }
    $groupNode = $dom->createElement( 'group' );
    $groupNode->setAttribute( 'id', $group->attribute( 'id' ) );
    $groupNode->setAttribute( 'identifier', $group->attribute( 'name' ) );
    $classList = eZContentClassClassGroup::fetchClassList( null, $group->attribute( 'id' ) );
    foreach( $classList as $class )
    {
        if ( in_array( $class->attribute( 'id' ), $classBlackList ) )
        {
            continue;
        }
        $classNode = $dom->createElement( 'class' );
        $classNode->setAttribute( 'id', $class->attribute( 'id' ) );
        $classNode->setAttribute( 'identifier', $class->attribute( 'identifier' ) );
        $classNode->setAttribute( 'name', $class->attribute( 'name' ) );
        $dataMap = $class->attribute( 'data_map' );
        foreach( $dataMap as $identifier => $attribute )
        {
            $attrNode = $dom->createElement( 'attribute' );
            $attrNode->setAttribute( 'id', $attribute->attribute( 'id' ) );
            $attrNode->setAttribute( 'identifier', $attribute->attribute( 'identifier' ) );
            $attrNode->setAttribute( 'name', $attribute->attribute( 'name' ) );
            $attrNode->setAttribute( 'type', $attribute->attribute( 'data_type_string' ) );
            $attrNode->setAttribute( 'is_required', $attribute->attribute( 'is_required' ) );
            $classNode->appendChild( $attrNode );
        }

        $groupNode->appendChild( $classNode );
    }
    $root->appendChild( $groupNode );
}

$xml = $dom->saveXML();
header( 'Content-Type: text/xml; charset=utf-8' );
header( 'Content-Length: ' . strlen( $xml ) );
header( 'X-Powered-By: eZ Publish' );
echo $xml;
eZExecution::cleanExit();
?>
