<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- $Id: xml2pdf.xsl 426576 2006-07-28 15:44:37Z jeremias $ -->
<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
     xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:template match ="root">

    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>

        <fo:simple-page-master master-name="first"
              margin-right="0in"
              margin-left="0in"
              margin-bottom="0in"
              margin-top="0in"
              page-width="6.625in"
              page-height="10.25in">
            <fo:region-body 
              background-color="#552DB2" 
              color="#000000"
              font-family="helvetica"></fo:region-body>
          </fo:simple-page-master>
  
          <fo:simple-page-master master-name="rest"
              margin-right="0in"
              margin-left="0in"
              margin-bottom="0in"
              margin-top="0in"
              page-width="6.625in"
              page-height="10.25in">
            <fo:region-body 
              background-color="#552DB2" 
              color="#000000"
              font-family="helvetica"></fo:region-body>
          </fo:simple-page-master>


        <fo:page-sequence-master master-name="psmA">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference master-reference="first" page-position="first" />
            <fo:conditional-page-master-reference master-reference="rest" page-position="rest" />
            <!-- recommended fallback procedure -->
            <fo:conditional-page-master-reference master-reference="rest" />
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="psmA">

        <fo:flow flow-name="xsl-region-body">

          <xsl:variable name="volume_count"><xsl:value-of select="count(/root/volumes/volume)" /></xsl:variable>

          <xsl:for-each select="/root/volumes/volume">

            <xsl:variable name="volume_idx"><xsl:value-of select="position()" /></xsl:variable>

            <xsl:variable name="MAX_COLS">2</xsl:variable>

            <xsl:variable name="MAX_ROWS">
              <xsl:choose>
                <xsl:when test="@volume_code='AF_1'">6</xsl:when>
                <xsl:when test="@volume_code='AF_2'">6</xsl:when>
                <xsl:when test="@volume_code='AF_3'">6</xsl:when>
                <xsl:when test="@volume_code='AF_4'">6</xsl:when>
                <xsl:otherwise>6</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
<!--
            <xsl:if test="string-length(@volume_page) > 0">
-->
              <xsl:call-template name="volume_page" />


                <xsl:variable name="volume_idx">
                  <xsl:value-of select="position()"/>
                </xsl:variable>

                <xsl:variable name="VOLUME_PAGE_COUNT">
                  <xsl:choose>
                    <xsl:when test="count(./issue) mod ($MAX_ROWS*$MAX_COLS) = 0"><xsl:value-of select="floor(count(./issue) div ($MAX_ROWS*$MAX_COLS))+1" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="(floor(count(./issue) div ($MAX_ROWS*$MAX_COLS)))+2" /></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                
                <xsl:for-each select="./issue">

                  <xsl:variable name="issue_idx_1">
                    <xsl:value-of select="position()"/>
                  </xsl:variable>
    
                  <xsl:if test="($issue_idx_1 - 1) mod ($MAX_ROWS * $MAX_COLS) = 0">

                      <xsl:for-each select="../issue">

                        <xsl:variable name="issue_idx_2">
                          <xsl:value-of select="position()"/>
                        </xsl:variable>

                        <xsl:if test="($issue_idx_2 &gt;= $issue_idx_1) and ($issue_idx_2 &lt; $issue_idx_1 + $MAX_ROWS)">

                          <xsl:choose>
                            <xsl:when test="ceiling(($issue_idx_2 div $MAX_ROWS) mod 2) = 1">

                              <xsl:call-template name="issue_group">
                                <xsl:with-param name="pos">
                                  <xsl:value-of select="$issue_idx_2"/>
                                </xsl:with-param>
                                <xsl:with-param name="MAX_ROWS"><xsl:value-of select="$MAX_ROWS" /></xsl:with-param>
                                <xsl:with-param name="MAX_COLS"><xsl:value-of select="$MAX_COLS" /></xsl:with-param>
                              </xsl:call-template>

                              <xsl:choose>

                                <xsl:when test="$issue_idx_2 = count(../issue)">
                                  <!--*** FOOTER2 ***-->
                                  <fo:block break-after='page'/>
<!--
<fo:block><fo:inline font-size="12pt">BROKE 1</fo:inline></fo:block>
-->
                                  <xsl:if test="$VOLUME_PAGE_COUNT mod 2 != 0">
                                    <xsl:call-template name="volume_extra_page"><xsl:with-param name="volume_code"><xsl:value-of select="../@volume_code" /></xsl:with-param></xsl:call-template>
                                    <fo:block break-after='page'/>
<!--
<fo:block><fo:inline font-size="12pt">BROKE 2</fo:inline></fo:block>
-->
                                  </xsl:if>

                                </xsl:when>

                                <xsl:when test="$issue_idx_2 mod $MAX_ROWS*$MAX_COLS = 0">
                                  <!--*** FOOTER1 ***-->
                                  <fo:block break-after='page'/>
<!--
<fo:block><fo:inline font-size="12pt">BROKE 3</fo:inline></fo:block>
-->

                                  <xsl:variable name="recordsperpage"><xsl:value-of select="$MAX_ROWS*$MAX_COLS" /></xsl:variable>

                                  <xsl:if test="(($issue_idx_2 + ($MAX_ROWS * ($MAX_COLS -1))) mod $recordsperpage = 0) and ($issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1)) >= count(../issue))">

                                    <xsl:call-template name="volume_extra_page"><xsl:with-param name="volume_code"><xsl:value-of select="../@volume_code" /></xsl:with-param></xsl:call-template>
                                    <xsl:if test="$volume_idx &lt; $volume_count">
                                      <fo:block break-after='page'/>
                                    </xsl:if>
<!--
<fo:block><fo:inline font-size="12pt">BROKE 4</fo:inline></fo:block>
<fo:block><fo:inline font-size="12pt">issue_idx_2: <xsl:value-of select="$issue_idx_2" /></fo:inline></fo:block>
<fo:block><fo:inline font-size="12pt">($issue_idx_2 * 2) mod ($MAX_ROWS*$MAX_COLS): <xsl:value-of select="($issue_idx_2 * 2) mod ($MAX_ROWS*$MAX_COLS)" /></fo:inline></fo:block>
<fo:block><fo:inline font-size="12pt">$issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1)): <xsl:value-of select="$issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1))" /></fo:inline></fo:block>
<fo:block><fo:inline font-size="12pt">count(../issue): <xsl:value-of select="count(../issue)" /></fo:inline></fo:block>
<fo:block><fo:inline font-size="12pt">($issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1)) >= count(../issue)): <xsl:value-of select="($issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1)) >= count(../issue))" /></fo:inline></fo:block>
-->
                                  </xsl:if>
                                </xsl:when>

                              </xsl:choose>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:if>



                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
<!--
            </xsl:if>
-->
          </xsl:for-each>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="volume_extra_page">
    <xsl:param name="volume_code" />

      <xsl:choose>
        <xsl:when test="$volume_code='AF_1'">
          <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="10.25in" scaling="uniform" src="url('./img/Marvel_Age_OA_14.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='AF_2'">
          <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="10.25in" scaling="uniform" src="url('./img/alpha-flight.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='AF_3'">
          <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="10.25in" scaling="uniform" src="url('./img/Mignola04.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='AF_4'">
          <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img/Alphaflight058cvrv2.jpg')" />
          </fo:block>
        </xsl:when>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="volume_page">

    <fo:block text-align="start" space-after.optimum="3pt" line-height="14pt" font-family="sans-serif" font-size="12pt" color="#FFFFFF" margin=".5in">

    <xsl:choose>
      <xsl:when test="@volume_code='AF_1'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
          <fo:external-graphic height="120px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Alpha_Flight_Logo2.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='AF_2'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
          <fo:external-graphic height="120px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Alpha_Flight_Logo2.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='AF_3'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
          <fo:external-graphic height="200px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Alpha_Flight_Logo4.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='AF_4'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
          <fo:external-graphic height="200px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Alpha_Flight_Logo4.jpg')" />
        </fo:block>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="@volume_code='AF_1'">

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight #1-13</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Classic X-Men #26-27</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">The Incredible Hulk Annual #8</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Machine Man #18</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Two-In-One #83-84</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Age #2</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">ROM #56-58</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='AF_2'">

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight #14-28</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Team-Up Annual #7</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Men/Alpha Flight #1-2</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='AF_3'">

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight #29-47</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight Annual #1</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">The Incredible Hulk #313</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Fanfare #28</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">The Avengers #272</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='AF_4'">

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight #48-66</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Alpha Flight Annual #2</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>
      <xsl:otherwise>
          <fo:block>
            <fo:inline font-size="12pt">WHY AM I HERE??? - I AM VERY CONFUSED!!!!</fo:inline>
          </fo:block>
      </xsl:otherwise>

    </xsl:choose>

    </fo:block>

    <fo:block break-after='page'/>
<!--
<fo:block><fo:inline font-size="12pt">BROKE 5</fo:inline></fo:block>
-->

  </xsl:template>


  <xsl:template name="issue_group">
    <xsl:param name="pos" />
    <xsl:param name="MAX_ROWS" />
    <xsl:param name="MAX_COLS" />

    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block>

              <!--POS:<xsl:value-of select="position()"/-->
              <xsl:call-template name="issue">
                <xsl:with-param name="pos">
                  <xsl:value-of select="position()"/>
                </xsl:with-param>
              </xsl:call-template>

            </fo:block>
          </fo:table-cell>
          <xsl:if test="position()+$MAX_ROWS &lt;= count(../issue)">
            <fo:table-cell>
              <fo:block>

              <!--POS2:<xsl:value-of select="position()+$MAX_ROWS"/-->
              <xsl:call-template name="issue">
                <xsl:with-param name="pos">
                  <xsl:value-of select="position()+$MAX_ROWS"/>
                </xsl:with-param>
              </xsl:call-template>
                </fo:block>
                </fo:table-cell>

          </xsl:if>

        </fo:table-row>
      </fo:table-body>
    </fo:table>

  </xsl:template>

  <xsl:template name="issue">
    <xsl:param name="pos" />

    <xsl:variable name="issue_idx">
      <xsl:value-of select="$pos"/>
    </xsl:variable>

    <fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">

      <xsl:variable name="IssueTitle">
<!--
        <xsl:call-template name="left-trim">
          <xsl:with-param name="s">
-->
            <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue Title']" />
<!--
          </xsl:with-param>
        </xsl:call-template>
-->
      </xsl:variable>
      <fo:block font-style="italic">
        <xsl:if test="string-length($IssueTitle) > 0">
        "<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue Title']" />"
        </xsl:if>
      </fo:block>
  
      <fo:block>
        <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Title']" /> #<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue']" />
        <fo:inline font-size="6pt"> (
          <xsl:call-template name="decodemonth">
            <xsl:with-param name="code">
              <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Month']" />
            </xsl:with-param>
          </xsl:call-template> <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Year']" />)
        </fo:inline>
      </fo:block>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Writer'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Writer: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Writer']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Artist'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Artist: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Artist']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Penciller'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Penciller: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Penciller']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Inker'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Inker: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Inker']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Colorist'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Colors: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Colorist']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Letterer'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Letterer: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Letterer']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Cover Artist'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Cover Artist: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Cover Artist']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Editor'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Editor: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Editor']" />
        </fo:block>
      </xsl:if>
  
      <xsl:if test="string-length(normalize-space(../issue[position()=$pos]/Fld[@Name='Editor In Chief'])) > 0">
        <fo:block>
        <fo:inline font-size="6pt">Editor-In-Chief: </fo:inline><!--span class="value"-->
          <xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Editor In Chief']" />
        </fo:block>
      </xsl:if>

    </fo:block>
    
  </xsl:template>

  <xsl:template name="decodemonth">
    <xsl:param name="code" />
    <xsl:choose>
      <xsl:when test="$code='1'">Jan.</xsl:when>
      <xsl:when test="$code='2'">Feb.</xsl:when>
      <xsl:when test="$code='3'">Mar.</xsl:when>
      <xsl:when test="$code='4'">Apr.</xsl:when>
      <xsl:when test="$code='5'">May</xsl:when>
      <xsl:when test="$code='6'">June</xsl:when>
      <xsl:when test="$code='7'">Jul.</xsl:when>
      <xsl:when test="$code='8'">Aug.</xsl:when>
      <xsl:when test="$code='9'">Sep.</xsl:when>
      <xsl:when test="$code='10'">Oct.</xsl:when>
      <xsl:when test="$code='11'">Nov.</xsl:when>
      <xsl:when test="$code='12'">Dec.</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="left-trim">
    <xsl:param name="s" />
  
    <xsl:choose>
      <xsl:when test="normalize-space(substring($s, 1, 1)) = ''">
        <xsl:call-template name="left-trim">
          <xsl:with-param name="s" select="substring($s, 2)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$s" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="right-trim">
    <xsl:param name="s" />
  
    <xsl:choose>
      <xsl:when test="normalize-space(substring($s, string-length($s))) = ''">
        <xsl:call-template name="right-trim">
          <xsl:with-param name="s" select="substring($s, 1, string-length($s) - 1)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$s" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>