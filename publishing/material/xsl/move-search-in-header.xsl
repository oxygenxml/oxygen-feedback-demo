<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns:whc="http://www.oxygenxml.com/webhelp/components"
    version="2.0">
    
    <xsl:template match="whc:include_html[@href]" mode="copy_template">
        <xsl:param name="hostRootElement" as="element()" select="/*" tunnel="yes"></xsl:param>
        <xsl:next-match>
            <xsl:with-param name="hostRootElement" select="$hostRootElement" tunnel="yes"/>
        </xsl:next-match>
    </xsl:template>
    
    <xsl:template match="whc:webhelp_search_input" mode="copy_template">
        <xsl:param name="outputComponent" as="xs:boolean" select="false()" tunnel="yes"/>
        <xsl:if test="$outputComponent">
            <xsl:next-match/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, 'wh_header_flex_container')]" mode="copy_template">
        <xsl:param name="hostRootElement" as="element()" select="/*" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates mode="copy_template"/>
            <xsl:apply-templates select="$hostRootElement//whc:webhelp_search_input" mode="copy_template">
                <xsl:with-param name="outputComponent" as="xs:boolean" select="true()" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:copy>
        
    </xsl:template>
    
    <!--  Add 'navbar-light' class to header  -->
    <xsl:template match="*[contains(@class, ' wh_header')]" mode="copy_template">
        <xsl:copy>
            <xsl:attribute name="class" select="concat(@class, ' navbar-light')"/>
            <xsl:apply-templates select="@* except @class" mode="copy_template"/>
            <xsl:apply-templates select="node()" mode="copy_template"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>