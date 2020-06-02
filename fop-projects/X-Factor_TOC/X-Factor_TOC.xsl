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

      <!--xsl:choose>
        <xsl:when test=""-->
        <fo:simple-page-master master-name="first"
              margin-right="0in"
              margin-left="0in"
              margin-bottom="0in"
              margin-top="0in"
              page-width="6.625in"
              page-height="10.25in">
            <fo:region-body 
              background-color="#000000" 
              color="#FFFFFF"
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
              background-color="#000000" 
              color="#FFFFFF"
              font-family="helvetica"></fo:region-body>
          </fo:simple-page-master>
        <!--/xsl:when>
        <xsl:otherwise>
          <fo:simple-page-master master-name="first"
              margin-right="0in"
              margin-left="0in"
              margin-bottom="0in"
              margin-top="0in"
              page-width="6.625in"
              page-height="10.25in">
            <fo:region-body 
              background-color="#FFFFFF" 
              color="#710000"
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
              background-color="#FFFFFF" 
              color="#710000"
              font-family="helvetica"></fo:region-body>
          </fo:simple-page-master>
        </xsl:otherwise>
      </xsl:choose-->


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

          <xsl:for-each select="/root/volumes/volume">

            <xsl:variable name="MAX_COLS">2</xsl:variable>

            <xsl:variable name="MAX_ROWS">
              <xsl:choose>
                <xsl:when test="@volume_code='XF_1'">7</xsl:when>
                <xsl:when test="@volume_code='XF_2'">7</xsl:when>
                <xsl:when test="@volume_code='INFERNO'">5</xsl:when>
                <xsl:when test="@volume_code='XF_4'">6</xsl:when>
                <xsl:when test="@volume_code='XANNUAL'">6</xsl:when>
                <xsl:when test="@volume_code='XF_5'">6</xsl:when>
                <xsl:when test="@volume_code='XF_6'">6</xsl:when>
                <xsl:when test="@volume_code='XCSONG'">6</xsl:when>
                <xsl:when test="@volume_code='XF_8'">6</xsl:when>
                <xsl:when test="@volume_code='XF_9'">7</xsl:when>
                <xsl:when test="@volume_code='XF_10'">6</xsl:when>
                <xsl:otherwise>6</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="volume_page" />

            <xsl:choose>
              <xsl:when test="@volume_code='XANNUAL'">
                <xsl:call-template name="volume_extra_page"><xsl:with-param name="volume_code"><xsl:value-of select="@volume_code" /></xsl:with-param></xsl:call-template>
                <fo:block break-after='page'/>
              </xsl:when>
              <xsl:otherwise>

                <xsl:variable name="volume_idx">
                  <xsl:value-of select="position()"/>
                </xsl:variable>

                <xsl:variable name="VOLUME_PAGE_COUNT">
                  <xsl:choose>
                    <xsl:when test="count(./issue) mod ($MAX_ROWS*$MAX_COLS) = 0"><xsl:value-of select="floor(count(./issue) div ($MAX_ROWS*$MAX_COLS))+1" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="(floor(count(./issue) div ($MAX_ROWS*$MAX_COLS)))+2" /></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                
                <!--
                <xsl:variable name="VOLUME_PAGE_COUNT"><xsl:value-of select="" /></xsl:variable>
                -->

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
<fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">$VOLUME_PAGE_COUNT: <xsl:value-of select="$VOLUME_PAGE_COUNT" /></fo:block>
<fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">$VOLUME_PAGE_COUNT mod 2: <xsl:value-of select="$VOLUME_PAGE_COUNT mod 2" /></fo:block>
-->
                                  <xsl:if test="$VOLUME_PAGE_COUNT mod 2 != 0">
<!--
<fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">WELCOME TO THE BACK PAGE</fo:block>
-->
                                    <xsl:call-template name="volume_extra_page"><xsl:with-param name="volume_code"><xsl:value-of select="../@volume_code" /></xsl:with-param></xsl:call-template>
                                    <fo:block break-after='page'/>
<!--
        <fo:block margin="0in">
        <fo:external-graphic width="6.625in" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img3/142_X_FACTOR_FOREVER_1.jpg')" />
        </fo:block>
-->

                                  </xsl:if>

                                </xsl:when>

                                <xsl:when test="$issue_idx_2 mod $MAX_ROWS*$MAX_COLS = 0">
                                  <!--*** FOOTER1 ***-->
                                  <fo:block break-after='page'/>
<!--
<fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">09</fo:block>
-->
                                  <xsl:if test="(($issue_idx_2 * 2) mod ($MAX_ROWS*$MAX_COLS) = 0) and ($issue_idx_2 + ($MAX_ROWS*($MAX_COLS - 1)) &gt;= count(../issue))">
                                    <!--fo:block space-after="5in" />
                                    <fo:block margin="1.15in">
                                      <fo:external-graphic height="4in" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X - X Factor Comic.JPG')" />
                                    </fo:block-->
<!--
<fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">WELCOME TO THE BACK PAGE (2)</fo:block>
-->
                                    <xsl:call-template name="volume_extra_page"><xsl:with-param name="volume_code"><xsl:value-of select="../@volume_code" /></xsl:with-param></xsl:call-template>
                                    <fo:block break-after='page'/>
                                  </xsl:if>
                                </xsl:when>

                              </xsl:choose>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:if>



                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:for-each>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template name="volume_extra_page">
    <xsl:param name="volume_code" />

    <!--
    <fo:block font-size="8pt" color="#FFFFFF" margin-left=".5in" margin-right=".5in" margin-top=".25in">WELCOME TO THE BACK PAGE (3)</fo:block>
    -->
      <xsl:choose>
        <!--xsl:when test="$volume_code='XF_1'"></xsl:when-->
        <xsl:when test="$volume_code='XF_2'">
         <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/xfactor18 - Archangel origin.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='INFERNO'">
         <fo:block margin-left=".04in" margin-top=".04in">
            <fo:external-graphic content-width="6.625in" content-height="10.10in" scaling="uniform" src="url('./img3/172541_20090617165246_large.jpg')" />
          </fo:block>
        </xsl:when>
        <!--xsl:when test="$volume_code='XF_4'"></xsl:when-->
        <xsl:when test="$volume_code='XANNUAL'">
         <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/Quesada_X_Factor_Annual_7.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XF_5'">
         <fo:block margin-left=".03in" margin-top=".04in">
            <fo:external-graphic content-width="6.625in" content-height="10.10in" src="url('./img3/X-Factor_originalart_68.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XF_6'">
         <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/STROMAN X-FACTOR.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XCSONG'">
         <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/92564-193331-x-cutioners-song_super.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XF_8'">
         <fo:block>
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/XfactorAnnual9Pinup.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XF_9'">
         <fo:block margin-top=".6in" margin-left=".125in">
            <fo:external-graphic content-width="6.375in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/Picture 074.gif.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:when test="$volume_code='XF_10'">
         <fo:block margin="0">
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./img3/X-factor 134 pg 20.jpg')" />
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block margin="0in">
            <fo:external-graphic width="6.625in" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img3/142_X_FACTOR_FOREVER_1.jpg')" />
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="volume_page">

    <fo:block text-align="start" space-after.optimum="3pt" line-height="14pt" font-family="sans-serif" font-size="12pt" color="#FFFFFF" margin=".5in">


    <xsl:choose>
      <xsl:when test="@volume_code='XF_1'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
          <fo:external-graphic height="120px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_12.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_2'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
        <fo:external-graphic height="148px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_3.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='INFERNO'">
        <fo:block space-after="2in" />
        <fo:block margin-left="1.3in" margin-bottom=".5in">
        <fo:external-graphic height=".5in" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Inferno_Logo.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_4'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
        <fo:external-graphic height="148px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_3.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XANNUAL'">
        <fo:block space-after="1in" />
      </xsl:when>
      <xsl:when test="@volume_code='XF_5'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
        <fo:external-graphic height="148px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_3.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_6'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
        <fo:external-graphic height="148px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_3.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XCSONG'">
        <fo:block space-after="1in" />
        <fo:block margin-left="1.2in">
        <fo:external-graphic content-height="5in" scaling="uniform" src="url('./img3/X-Cutioner's_Song_Cover.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_8'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".85in">
        <fo:external-graphic height="148px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_3.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_9'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".5in">
        <fo:external-graphic height="160px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_9.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:when test="@volume_code='XF_10'">
        <fo:block space-after="2in" />
        <fo:block margin-left=".5in">
        <fo:external-graphic height="160px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/X-Factor_Logo_9.jpg')" />
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block space-after="2in" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>

            <xsl:when test="@volume_code='XF_1'">
              
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                 <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">December 1985 - April 1987</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
              
              <fo:block space-after=".25in" />

              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                 <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">X-Factor #1-15</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">X-Factor Annual #1</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">Phoenix: the Untold Story</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">What If Volume 1 #27</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">What If Volume 2 #32</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">Marvel Age #33, 39</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">Fantastic Four #286</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">The Avengers #263</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">Thor #373-374</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block text-align="center">Power Pack #27</fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </xsl:when>

      <xsl:when test="@volume_code='XF_2'">

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">April 1985 - September 1988</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #16-32</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor Annual #2-3</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Thor #378</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Mephiso Vs X-Factor #2</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">The Incredible Hulk #336-337</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Age #58</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Power Pack #35</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='INFERNO'">

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">October 1988 - April 1989</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #33-39</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor Annual #4</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Terminators #1-4</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Uncanny X-Men #239-243</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">New Mutants #71-73</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Daredevil #262</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Power Pack #42-44</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">What If v2 #6</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XF_4'">


        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">January 1989 - October 1990</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #40-59</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor Special: Prisoner of Love</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Marvel Comics Presents #17-24</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">New Mutants #76</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XANNUAL'">
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Men Annual Crossovers</fo:block><fo:block text-align="center">1990-1992</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".5in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block margin-left=".5in" >
                  <fo:external-graphic width="275px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/DOFP_Logo.jpg')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Fantastic Four Annual #23</fo:block>
                <fo:block text-align="center">X-Factor Annual #5</fo:block>
                <fo:block text-align="center">New Mutants Annual #6</fo:block>
                <fo:block text-align="center">Uncanny X-Men Annual #14</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".5in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block margin-left=".35in" >
                <fo:external-graphic width="275px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/KOP_Logo.jpg')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">New Mutants Annual #7</fo:block>
                <fo:block text-align="center">New Warriors Annual #1</fo:block>
                <fo:block text-align="center">Uncanny X-Men Annual #15</fo:block>
                <fo:block text-align="center">X-Factor Annual #6</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".5in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block margin-left=".4in" >
                  <fo:external-graphic width="275px" content-height="scale-to-fit" scaling="uniform" content-width="100%" src="url('./img/Shattershot_Logo 001.jpg')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Men Annual #1</fo:block>
                <fo:block text-align="center">Uncanny X-Men Annual #16</fo:block>
                <fo:block text-align="center">X-Factor Annual #7</fo:block>
                <fo:block text-align="center">X-Force Annual #1</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XF_5'">
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">November 1990 - September 1991</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #60-70</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Uncanny X-Men #270-272, #278-280</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">New Mutants #95-97</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XF_6'">


        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">October 1991 - October 1992</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body> 
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #71-83</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">The Incredible Hulk #390-392</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XCSONG'">


        <!--fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Men</fo:block><fo:block text-align="center">X-Cutioner's Song</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table-->

        <fo:block space-after=".25in"/>

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Uncanny X-Men #294-297</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #84-86</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Men #14-16</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Force #16-18</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Stryfe's Strike File</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XF_8'">


        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">February 1993 - June 1994</fo:block>
              </fo:table-cell>
            </fo:table-row> 
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #87-103</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor Annual #8-9</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">Spider-Man and X-Factor #1-3</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

      <xsl:when test="@volume_code='XF_9'">

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">July 1994 - December 1996</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #104-129</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>
  
      <xsl:when test="@volume_code='XF_10'">

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">January 1997 - September 1998</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>

        <fo:block space-after=".25in" />

        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor #130-149</fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">X-Factor Flashback #-1</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:when>

    </xsl:choose>

    </fo:block>

    <fo:block break-after='page'/>

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

      <fo:block font-style="italic">
        "<xsl:value-of select="../issue[position()=$pos]/Fld[@Name='Issue Title']" />"
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

</xsl:stylesheet>