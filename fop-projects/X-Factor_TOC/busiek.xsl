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
              background-color="#FFFFFF" 
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
              background-color="#FFFFFF" 
              color="#000000"
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

          <fo:block margin-left="0in" margin-top="0in">
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./busiek/1.jpg')" />
          </fo:block>          

          <fo:block margin-left="59px" margin-top="0in">
            <fo:external-graphic content-width="279px" content-height="scale-to-fit" scaling="uniform" src="url('./busiek/Phoenix.jpg')" />
          </fo:block>          

          <fo:block font-size="9pt" margin-left=".5in" margin-right=".5in">
            While hunting through my files for something, I turned this up. It's my typed notes to myself for the story idea that eventually got used at Marvel (by Roger Stern, John Byrne and Bob Layton) for the resurrection of Jean Grey.  A few notes:
          </fo:block>          
            
          <fo:block font-size="9pt" margin-left=".5in" margin-right=".5in" margin-top=".1in">
            * This wasn't the first version of the story. The first was entirely verbal, cooked up sometime around May or June of 1980. Richard Howell, Carol Kalish and I had heard through the grapevine about the impending death of Phoenix and then-editor in chief Jim Shooter's rules for what kind of circumstances it would take to resurrect her. We took that as a creative challenge, and came up with resurrection plans. Richard and Carol's involved the holo-empathic crystal Lilandra gave to the X-Men, as I recall, while mine involved the revelation that Jean had never really died. We had a pleasant evening wrangling over the clear superiority of our own version over the other version, and left it at that. It's all we'd really set out to do.
          </fo:block>          
            
          <fo:block font-size="9pt" margin-left=".5in" margin-right=".5in" margin-top=".1in">
            * Sometime between then and May 1982, when I graduated college and sold my first script, I started taking notes for various Marvel series I hoped to write someday, to make sure I didn't forget any of my "great ideas," few of which were great, or even memorable. This document would have been written sometime in there. I can tell it wasn't simply notes on the resurrection storyline, but plans for something more extended, what with that Wolverine plot-bit stuck in the middle, that if I remember correctly, was intended to start of a storyline to get Wolverine to try to stop killing people left and right, under what I thought was the dodgy rationale of, "He comes at me with a knife (while I'm invading his lair), I'll come at him with a gun," or some such. Somewhere I may still have my files of where I would have gone with it all, which I think involved the X-Men becoming teachers to a new generation of mutants. But they may be mercifully lost.
          </fo:block>          
            
          <fo:block font-size="9pt" margin-left=".5in" margin-right=".5in" margin-top=".1in">
            * Nobody at Marvel ever saw this document. In fact, outside of my circle of friends at college at the time, no one else may ever have seen this until now. The plot idea was transmitted vocally-I recounted a version of it to Roger Stern at a convention in Ithaca in 1983, he passed it on to John Byrne over the phone at some later point, and John passed it on to Bob Layton when he heard about the plans for the creation of X-Factor. So this version was never on the table. All Marvel had was the bare concept of how Phoenix could have existed while Jean was still alive at the bottom of Jamaica Bay, translated through a game of "Telephone." Although I do think the idea of the Phoenix Force behind it, which doesn't appear in these notes, was part of my original idea, or at least part of what I told Roger. But at this point I can't say for sure.
          </fo:block>          
            
          <fo:block font-size="9pt" margin-left=".5in" margin-right=".5in" margin-top=".1in" break-after="page">
            Anyway, here it is, for anyone who's curious about what the idea started out as...
          </fo:block>          

          <fo:block margin-left="0in" margin-top="0in" break-after="page">
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./busiek/JeanPlot1lg.jpg')" />
          </fo:block>          

          <fo:block margin-left="0in" margin-top="0in" break-after="page">
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./busiek/JeanPlot2lg.jpg')" />
          </fo:block>          

          <fo:block margin-left="0in" margin-top="0in">
            <fo:external-graphic content-width="6.625in" content-height="scale-to-fit" scaling="uniform" src="url('./busiek/xfactor1unpubGL.jpg')" />
          </fo:block>          

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>


</xsl:stylesheet>