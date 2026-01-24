<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei"
  version="3.0">

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:param name="index" select="document('index.xml')"/>
  <xsl:param name="outputdirectory">tei</xsl:param>
  <xsl:param name="eventcontent">label</xsl:param>

  <xsl:variable
    name="filename"
    select="replace(tokenize(base-uri(.), '/')[last()], '.xml', '')"/>

  <xsl:variable name="meta" select="$index//item[@file eq $filename]"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$meta">
        <xsl:variable
          name="target"
          select="concat($outputdirectory, '/', $meta/@slug, '.xml')"/>
        <xsl:message select="$filename || ': ' || $target"/>
        <xsl:result-document href="{$target}">
          <xsl:apply-templates select="tei:TEI"/>
        </xsl:result-document>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unknown document ID: </xsl:text>
          <xsl:value-of select="$filename"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <TEI type="dracor" xml:id="{$meta/@id}" xml:lang="hu">
      <xsl:apply-templates/>
    </TEI>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <xsl:variable name="dates" select="
      /tei:TEI/tei:teiHeader//tei:sourceDesc//tei:bibl
        [@type='originalSource' or @type='firstEdition']
        /tei:date
          [@type='print' or  @type='premiere' or @type='written']
          [@when != '' or @notBefore or @notAfter]"/>
    <xsl:variable
      name="wd-idno"
      select="/tei:TEI//tei:publicationStmt/tei:idno[@type='wikidata']"/>

    <teiHeader>
      <xsl:apply-templates/>
    </teiHeader>

    <xsl:if test="not(/tei:TEI/tei:standOff) and ($dates or $meta/@wikidata)">
      <standOff>
        <xsl:if test="$dates">
          <listEvent>
            <xsl:for-each select="$dates">
              <event type="{@type}">
                <xsl:for-each select="@when|@notBefore|@notAfter">
                  <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:for-each>
                <xsl:variable name="content" select="text()"/>
                <xsl:choose>
                  <xsl:when test="not($content) or $content eq @when">
                    <desc/>
                  </xsl:when>
                  <xsl:when test="$eventcontent eq 'label'">
                    <label><xsl:value-of select="$content"/></label>
                  </xsl:when>
                  <xsl:when test="$eventcontent eq 'desc'">
                    <desc><xsl:value-of select="$content"/></desc>
                  </xsl:when>
                  <xsl:when test="string-length($content) &lt; 10">
                    <label><xsl:value-of select="$content"/></label>
                  </xsl:when>
                  <xsl:otherwise>
                    <desc><xsl:value-of select="$content"/></desc>
                  </xsl:otherwise>
                </xsl:choose>
              </event>
            </xsl:for-each>
          </listEvent>
        </xsl:if>
        <xsl:call-template name="list-relation"/>
      </standOff>
    </xsl:if>
  </xsl:template>

  <!--
    insert Wikidata ID into existing standOff element not having a wikidata
    listRelation
  -->
  <xsl:template match="tei:standOff[not(tei:listRelation[@name='wikidata'])]">
    <standOff>
      <xsl:apply-templates/>
      <xsl:call-template name="list-relation"/>
    </standOff>
  </xsl:template>

  <xsl:template name="list-relation">
    <xsl:if test="$meta/@wikidata">
      <listRelation>
        <relation
          name="wikidata"
          active="https://dracor.org/entity/{$meta/@id}"
          passive="http://www.wikidata.org/entity/{$meta/@wikidata}"/>
      </listRelation>
    </xsl:if>
  </xsl:template>

  <!-- remove type="main" from title -->
  <xsl:template match="tei:titleStmt/tei:title[@type='main']/@type"></xsl:template>

  <!-- remove empty elements -->
  <xsl:template match="(tei:l)[normalize-space() = '']"></xsl:template>

  <!-- strip old elements  -->
  <xsl:template match="
    tei:sourceDesc//tei:bibl[@type='originalSource' or @type='firstEdition']
      /tei:date[@type='print' or  @type='premiere' or @type='written']" />
  <xsl:template match="tei:publicationStmt/tei:idno[@type='wikidata']" />
  <xsl:template match="tei:bibl[
    @type='originalSource' and
    not(*[local-name!='date'])
    and normalize-space()=''
  ]"/>
  <xsl:template match="tei:publicationStmt/tei:idno[@type='dracor']"/>
</xsl:stylesheet>
