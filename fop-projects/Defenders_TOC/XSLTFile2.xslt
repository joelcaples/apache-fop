<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp  "&#160;">
  <!ENTITY slash "&#47;">
  <!ENTITY gt    "&#62;">
  <!ENTITY lt    "&#60;">
]>

  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="html" indent="yes"/>

  <xsl:variable name="MAX_ROWS">5</xsl:variable>
  <xsl:variable name="MAX_COLS">2</xsl:variable>

  <xsl:template match="/">

    <xsl:variable name="display_mode">1</xsl:variable>

    <html>
      <head>
        <style>
          body            {font-family:helvetica; color:white; background-color:#191970}
          /*.report         {border:5px solid navy;}*/
          .reportheading  {background-color: #191970; color: #FFFFFF }
          .oddrow         {background-color: #C0C0C0; color:#191970 }
          .evenrow        {background-color: #FFFFFF; color:#191970 }
          .issuename      {font-weight:bold; font-size:xx-large}
          .issuetitle     {font-style:italic; font-size:xx-large}
          .value          {font-weight:bold; font-size:xx-large}
          .footer         {page-break-before: always}
          .issue          {vertical-align:text-top}
          .volume_title   {font-weight:bold; font-size:xx-large}
          .toc_summary    {font-weight:bold; font-size:xx-large;vertical-align:text-top;}
        </style>
        <link rel="stylesheet" media="print" type="text/css" href="print.css" />
      </head>
      <body>

        <xsl:choose>
          <xsl:when test="$display_mode = 0">
            <xsl:call-template name="table_output"></xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="floating_output"></xsl:call-template>
          </xsl:otherwise>      
        </xsl:choose>

      </body>

    </html>

  </xsl:template>

  <xsl:template name="table_output">


        <xsl:for-each select="/root/volumes/volume">

          <xsl:variable name="volume_idx">
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <table class="report">

            <tr class="reportheading">
              <xsl:for-each select="/root/columns/column">
                <td>
                  <xsl:value-of select="@FldName"/>
                </td>
              </xsl:for-each>
            </tr>

            <xsl:for-each select="./issue">

              <xsl:variable name="issue_idx">
                <xsl:value-of select="position()"/>
              </xsl:variable>

              <tr>

                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">evenrow</xsl:when>
                    <xsl:otherwise>oddrow</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>

                <xsl:for-each select="Fld">
                  <td>
                    <xsl:value-of select="."/>
                  </td>
                </xsl:for-each>

                <!--xsl:for-each select="/root/columns/column">
                  <td>
                    <xsl:value-of select="/root/volumes/volume[position() = $volume_idx]/issue[position() = $issue_idx]/Fld[@Name=./@FldName]"/-->

                <!--
                    <br/>AAA
                    <xsl:value-of select="/root/volumes/volume[position() = $volume_idx]/@volume_code" />
                    <br/>BBB
                    <xsl:value-of select="count(/root/volumes/volume[position() = $volume_idx]/issue[position() = $issue_idx]/Fld)" />
                    <br/>CCC
                    <xsl:value-of select="/root/volumes/volume[position() = $volume_idx]/issue[position() = $issue_idx]/Fld" />
                    <br/>DDD
                    <xsl:value-of select="/root/volumes/volume[position() = $volume_idx]/issue[position() = $issue_idx]/Fld[@Name=./@FldName]/../../@volume_code"/>
                    <br/>EEE
                    <xsl:value-of select="./@FldName" />
                    <br/>FFF
                    <xsl:value-of select="/root/volumes/volume[position() = $volume_idx]/issue[position() = $issue_idx]/Fld[@Name=./@FldName]"/>
                    -->

                <!--/td>
                </xsl:for-each-->

              </tr>

            </xsl:for-each>

          </table>

        </xsl:for-each>

  </xsl:template>

  <xsl:template name="floating_output">

    <xsl:for-each select="/root/volumes/volume">

      <xsl:call-template name="volume_page" />
      
      <xsl:variable name="volume_idx">
        <xsl:value-of select="position()"/>
      </xsl:variable>

      <xsl:for-each select="./issue">
        <xsl:variable name="issue_idx_1">
          <xsl:value-of select="position()"/>
        </xsl:variable>
<!--$issue_idx_1:<xsl:value-of select="$issue_idx_1"/><br/-->
        <xsl:if test="(position() - 1) mod ($MAX_ROWS * $MAX_COLS) = 0">

          <table width="1988px" height="3075px" border="1" cellspacing="0">
            <tr>
              <td class="volume_title" align="center" valign="top">

                <xsl:for-each select="../issue">
                  <xsl:variable name="issue_idx_2">
                    <xsl:value-of select="position()"/>
                  </xsl:variable>
<!--$issue_idx_2:<xsl:value-of select="$issue_idx_2"/><br/-->
<!--($issue_idx_2 &gt;= $issue_idx_1) and ($issue_idx_2 &lt;= $issue_idx_1 + ($MAX_ROWS * $MAX_COLS)):<xsl:value-of select="($issue_idx_2 &gt;= $issue_idx_1) and ($issue_idx_2 &lt;= $issue_idx_1 + ($MAX_ROWS * $MAX_COLS))"/><br/-->
                  <xsl:if test="($issue_idx_2 &gt;= $issue_idx_1) and ($issue_idx_2 &lt; $issue_idx_1 + $MAX_ROWS)">
                    <xsl:choose>

                      <xsl:when test="ceiling((position() div $MAX_ROWS) mod 2) = 1">

                        <xsl:call-template name="issue_group">
                          <xsl:with-param name="pos">
                            <xsl:value-of select="position()"/>
                          </xsl:with-param>
                        </xsl:call-template>

                        <xsl:choose>
                          <xsl:when test="position() = count(../issue)">
                            <!--*** FOOTER2 ***-->
                            <p class="footer" />
                          </xsl:when>
                          <xsl:when test="position() mod $MAX_ROWS*$MAX_COLS = 0">
                            <!--*** FOOTER1 ***-->
                            <p class="footer" />
                          </xsl:when>
                        </xsl:choose>

                      </xsl:when>

                    </xsl:choose>
                  </xsl:if>
                </xsl:for-each>
              </td>
            </tr>
          </table>
        </xsl:if>
      </xsl:for-each>
  
    </xsl:for-each>

  </xsl:template>

    
  <xsl:template name="floating_output_group">
    
  </xsl:template>

  <xsl:template name="volume_page">

    <table width="1988px" height="3075px" border="1" cellspacing="0">
      <tr>
        <td class="volume_title" align="center" valign="top">

          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />

          <img src="Defenders_Logo.jpg" />

          <br />
          
          <xsl:choose>
            <xsl:when test="@volume_code='DEFENDERS_V5'">
              The Defenders Jan '81 - Jun '82
              <br />
              <br />
              <table>
                <tr>
                  <td class="toc_summary">The Defenders</td>
                  <td class="toc_summary">&nbsp;#92-108</td>
                </tr>
                <tr>
                  <td class="toc_summary">Marvel Team-Up</td>
                  <td class="toc_summary">&nbsp;#101, #111, #116</td>
                </tr>
                <tr>
                  <td class="toc_summary">Captain America</td>
                  <td class="toc_summary">&nbsp;#268</td>
                </tr>
              </table>
            </xsl:when>
            <xsl:when test="@volume_code='DEFENDERS_V6'">
              The Defenders Jul '82 - Oct '83
              <br />
              <br />
              <table>
                <tr>
                  <td class="toc_summary">The Defenders</td>
                  <td class="toc_summary">&nbsp;#142-152</td>
                </tr>
                <tr>
                  <td class="toc_summary">Marvel Team-Up</td>
                  <td class="toc_summary">&nbsp;#119, #124</td>
                </tr>
                <tr>
                  <td class="toc_summary">Avengers Annual</td>
                  <td class="toc_summary">&nbsp;#11</td>
                </tr>
              </table>
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>
    </table>

    <!--*** FOOTER ***-->
    <p class="footer" />

  </xsl:template>    
    
  <xsl:template name="issue_group">
    <xsl:param name="pos" />
    <table class="report" width="100%">
      <tr>
      <td class="issue" width="50%">
        <!--POS:<xsl:value-of select="position()"/-->
        <xsl:call-template name="issue">
        <xsl:with-param name="pos">
          <xsl:value-of select="position()"/>
        </xsl:with-param>
        </xsl:call-template>
      </td>
      <!--td>XXXXX</td-->
      <xsl:if test="position()+$MAX_ROWS &lt;= count(../issue)">
        <td class="issue">
          <!--POS2:<xsl:value-of select="position()+$MAX_ROWS"/-->
          <xsl:call-template name="issue">
            <xsl:with-param name="pos">
              <xsl:value-of select="position()+$MAX_ROWS"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        </xsl:if>      
    </tr>
    </table>
  </xsl:template>
  
  <xsl:template name="issue">
    <xsl:param name="pos" />

    <xsl:variable name="issue_idx">
      <xsl:value-of select="$pos"/>
    </xsl:variable>

    <span class="issuetitle">
      "<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue Title']" />"
    </span><br />
    <span class="issuename">
      <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Title']" />&nbsp;#<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue']" />
    </span>&nbsp;(
    <xsl:call-template name="decodemonth">
      <xsl:with-param name="code">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Mo']" />
      </xsl:with-param>
    </xsl:call-template>&nbsp;<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Year']" />)

    <br />

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Writer']) > 0">
      Writer: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Writer']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Artist']) > 0">
      Artist: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Artist']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Penciller']) > 0">
      Penciller: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Penciller']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Inker']) > 0">
      Inker: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Inker']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Colorist']) > 0">
      Colors: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Colorist']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Letterer']) > 0">
      Letterer: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Letterer']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Cover Artist']) > 0">
      Cover Artist: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Cover Artist']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Editor']) > 0">
      Editor: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Editor']" />
      </span><br />
    </xsl:if>

    <xsl:if test="string-length(../issue[position()=$pos]/Fld[@Name='Editor In Chief']) > 0">
      Editor-In-Chief: <span class="value">
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Editor In Chief']" />
      </span><br />
    </xsl:if>

    <br/><br/>

  </xsl:template>
  
  <xsl:template name="decodemonth">
    <xsl:param name="code" />
      <xsl:choose>
        <xsl:when test="$code='1'">Jan.</xsl:when>
        <xsl:when test="$code='2'">Feb.</xsl:when>
        <xsl:when test="$code='3'">Mar.</xsl:when>
        <xsl:when test="$code='4'">Apr.</xsl:when>
        <xsl:when test="$code='5'">May</xsl:when>
        <xsl:when test="$code='6'">Jun.</xsl:when>
        <xsl:when test="$code='7'">Jul.</xsl:when>
        <xsl:when test="$code='8'">Aug.</xsl:when>
        <xsl:when test="$code='9'">Sep.</xsl:when>
        <xsl:when test="$code='10'">Oct.</xsl:when>
        <xsl:when test="$code='11'">Nov.</xsl:when>
        <xsl:when test="$code='12'">Dec.</xsl:when>
      </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
