<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"
    xmlns:ufn="urn:user-defined-functions">

  <msxsl:script language="CSharp" implements-prefix="ufn">
    <![CDATA[
      private static readonly Regex Pattern = new Regex(@"(?<!\.vshost\.exe)\.(?:dll|config)$", RegexOptions.IgnoreCase);
      public bool isAcceptedFileType(string filename)
      {
          return filename != null && Pattern.IsMatch(filename);
      }
    ]]>
  </msxsl:script>
  
  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>

  <xsl:output method="xml" indent="yes" />

  <xsl:template match="wix:Directory" />
  <xsl:template match="@Directory">
    <xsl:attribute name="Directory">INSTALLDIR</xsl:attribute>
  </xsl:template>

  <xsl:key name="unwanted-files" match="wix:Component[not(ufn:isAcceptedFileType(wix:File/@Source))]" use="@Id" />
  <xsl:template match="wix:Component[key('unwanted-files', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('unwanted-files', @Id)]" />
  
</xsl:stylesheet>