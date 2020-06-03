<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes" />
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
  <xsl:comment xml:space="preserve">
  
  Generated file! 
  
  This file contains the targets that are marked with &lt;?convert_2x?> from the 
  main build_dita_template.xml file.
  
  For DITA OT 3.x the XSLT task calls are wrapped in a "pipeline" element. 
  Using this element in DITA OT 2.x makes the Dost XsltModule implementation throw 
  a NPE when using @in and @out attributes.
  
  This file contains the rewritten targets: the XSLT task withuot the "pipeline" 
  element around them, adds attributes like @processor, @force, @classpath, and 
  the "factory" element.   
  
  
  </xsl:comment>
  <xsl:apply-templates select="/*"/>
  </xsl:template>
  
  <xsl:template match="/*">
    <project>
      <xsl:apply-templates select="@*" />
      <xsl:attribute name="name"><xsl:value-of select="@name" />.2x</xsl:attribute>
      <xsl:apply-templates select="target[processing-instruction('convert_2x')]" mode="convert_2x" />
    </project>
  </xsl:template>

  <xsl:template match="node() |text()| @*" mode="convert_2x">
    <xsl:copy>
      <xsl:apply-templates select="node() | text()| @*" mode="convert_2x" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="target[processing-instruction('convert_2x')]" mode="convert_2x">
    <xsl:text xml:space="preserve">
    
    
    </xsl:text>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="convert_2x" />
      <xsl:attribute name="name"><xsl:value-of select="substring-before(@name, '.3x')" />.2x</xsl:attribute>
      <xsl:apply-templates select="node()" mode="convert_2x" />
    </xsl:copy>
    <xsl:text xml:space="preserve">
    
    
    </xsl:text>
  </xsl:template>

  <xsl:template match="processing-instruction('convert_2x')" mode="convert_2x"/>


  <xsl:template match="target[processing-instruction('convert_2x')]/@if" mode="convert_2x">
    <xsl:attribute name="unless"><xsl:value-of select="." /></xsl:attribute>
  </xsl:template>

  <xsl:template match="target[processing-instruction('convert_2x')]//pipeline" mode="convert_2x">
    <xsl:apply-templates select="xslt" mode="convert_2x" />
  </xsl:template>

  <xsl:template match="xslt" mode="convert_2x">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="convert_2x" />
      <xsl:attribute name="force">yes</xsl:attribute>
      <xsl:attribute name="processor">trax</xsl:attribute>
      <xsl:attribute name="classpathref">dost.class.path</xsl:attribute>
      <xsl:if test="not(factory)">
        <factory name="net.sf.saxon.TransformerFactoryImpl" />
      </xsl:if>
      <xsl:apply-templates select="*" mode="convert_2x" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
