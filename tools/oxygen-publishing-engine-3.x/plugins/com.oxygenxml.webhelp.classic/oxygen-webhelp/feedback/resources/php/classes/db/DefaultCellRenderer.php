<?php
/*

Oxygen WebHelp Plugin
Copyright (c) 1998-2020 Syncro Soft SRL, Romania.  All rights reserved.

*/

/**
 * Default cell renderer
 *
 * @author serban
 */
class DefaultCellRenderer implements ICellRenderer
{
    private $class;
    private $tag;
    private $name;

    function __construct($tag = "div", $tagClass = null)
    {
        $this->class = $tagClass;
        $this->tag = $tag;
    }

    /**
     * Get rendered output for the specified field
     *
     * @param String $fieldName field name
     * @param String $fieldValue field value
     * @return String
     */
    function render($fieldName, $fieldValue)
    {

        $toReturn = "<" . $this->tag;
        if ($this->class != null) {
            $toReturn .= " class=\"" . $this->class . "\"";
        }
        $toReturn .= ">" . htmlentities($fieldValue);
        $toReturn .= "</" . $this->tag . ">";

        return $toReturn;
    }

    function setAName($name)
    {
        $this->name = $name;
    }

}

?>