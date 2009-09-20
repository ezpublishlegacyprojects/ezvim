<?php
/*
 * $Id$
 * $HeadURL$
 *
 */

class eZDevTools
{

    /**
     * checkTemplate 
     * 
     * @param mixed $tplFile 
     * @static
     * @access public
     * @return array
     */
    public static function checkTemplate( $tplFile )
    {
        $lines = array();
        require_once 'kernel/common/template.php';
        $tpl = templateInit();
        $data = $tpl->validateTemplateFile( $tplFile );
        if ( !$data )
        {
            if ( $tpl->hasErrors() )
            {
                $errors = $tpl->errorLog();
                $lines = array_merge( $lines, self::formatInfos( $errors, $tplFile ) );
            }
            if ( $tpl->hasWarnings() )
            {
                $warnings = $tpl->warningLog();
                $lines = array_merge( $lines, self::formatInfos( $warnings, $tplFile ) );
            }
        }
        return $lines;
    }


    /**
     * Format the error lines for vim
     * 
     * @param array $infos
     * @param string $tplFile 
     * @static
     * @access private
     * @return array
     */
    private static function formatInfos( array $infos, $tplFile )
    {
        $lines = array();
        foreach( $infos as $info )
        {
            $text = self::formatPlacement( $info, $tplFile );
            $text .= ':';
            if ( isset( $info['name'] ) && $info['name'] )
            {
                $text .= $info['name'] . ' ';
            }
            $text .= str_replace( "\n", " ", $info['text'] );
            $lines[] = $text;
        }
        return $lines;
    }


    /**
     * Format the starting line and column of the error
     * 
     * @param array $infos 
     * @param string $tplFile
     * @static
     * @access private
     * @return string
     */
    private static function formatPlacement( array $infos, $tplFile )
    {
        $cols = '1';
        $line = '0';
        if ( isset( $infos['placement'] ) && $infos['placement'] )
        {
            $cols = $infos['placement']['start']['column'];
            $line = $infos['placement']['start']['line'];
        }
        else
        {
            // eZ Publish template engine doesn't always return
            // the placement of the error... Let's try to guess
            // the line number from the error message
            if ( preg_match( '@' . preg_quote( $tplFile, '@' ) . ':([0-9]+)@', $infos['text'], $matches ) )
            {
                $line = $matches[1];
            }
        }
        return $line . ' ' . $cols;
    }




}


?>
