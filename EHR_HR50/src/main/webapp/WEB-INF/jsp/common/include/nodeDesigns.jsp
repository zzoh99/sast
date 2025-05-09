<%@ page language="java"  contentType="text/html; charset=UTF-8"%>


<!-- design2_1~6 은 다 똑같고 <NodeUnit Type="TextBlock" Binding="ORG_NM" 의 Background="#8d9ba6" 만 다름..(소속레벨별 색깔을 달리 적용해주기 위해서임)-->
<!-- design4_1~6 은 다 똑같고 <NodeUnit Type="TextBlock" Binding="ORG_NM" 의 Background="#8d9ba6" 만 다름..(소속레벨별 색깔을 달리 적용해주기 위해서임)-->


<!-- ==================================design1==================================이거 안씁니다.. -->
	  <NodeDesign Name="design1" Width="150" Height="33" BorderThickness="1" BorderBrush="#cccccc" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#a5afb8" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#8d9ba6" />
		<NodeUnit Type="TextBlock" Text="(주)골프존" Top="0" Left="0" Width="150" Height="33" FontBold= "True"  VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#fff"/>
	  </NodeDesign>
<!-- ==================================design1==================================이거 안씁니다.. -->

<!-- ==================================design2(트리조건 '소속', '소속+사원' 으로 검색시 적용되는 디자인)================================== -->
	  <NodeDesign Name="design2" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_1" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#8d9ba6" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_2" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#f15979" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_3" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#00b5ad" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_4" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#65b000" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_5" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#f7941d" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design2_6" Width="150" Height="53" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="144" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="144" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="144" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#CC99CC" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666666"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="33" Left="0" Width="70" Height="20" HorizontalAlignment="Right" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="/" Top="33" Left="0" Width="150" Height="20" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="33" Left="80" Width="70" Height="20" HorizontalAlignment="Left" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666666" UseHandCursor="true"/>
	  </NodeDesign>
<!-- ==================================design2(트리조건 '소속', '소속+사원' 으로 검색시 적용되는 디자인)================================== -->

<!-- ==================================design3================================== -->
	  <NodeDesign Name="design3" Type="Grid" UseListUnit="True" Columns="1" Rows="1" Width="150" BorderThickness="1" BorderBrush="#cccccc" >
		 <NodeUnit Type="List" Column="0" Row="1" Width="150" >
		    <NodeUnit Type="Grid" Columns="2" Rows="1" Width="150" BorderThickness="0 0 0.5 0" BorderBrush="#cccccc"  Background="#F9F9F9">
		    <NodeUnit Type="TextBlock" Column="0" Row="0" Width="80" Height="17" Binding="NAME" Background="Transparent" VerticalAlignment="Center" FontSize="11" FontFamily="돋움" Foreground="#666" UseClick="true" UseHandCursor="true"/>
			<NodeUnit Type="TextBlock" Column="1" Row="0" Width="70" Height="17" Binding="JIKWEE_NM" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseClick="true" UseHandCursor="true"/>
		  	</NodeUnit>
		</NodeUnit>
	  </NodeDesign>
<!-- ==================================design3================================== -->

<!-- ==================================design4(트리조건 '소속+사원+사진', '소속+사원+사진+리스트' 으로 검색시 적용되는 디자인)================================== -->
	  <NodeDesign Name="design4" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="Transparent" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_1" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#8d9ba6" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_2" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#f15979" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_3" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#00b5ad" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_4" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#65b000" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_5" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#f7941d" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
	  <NodeDesign Name="design4_6" Width="160" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="TextBlock" Top="3" Left="3" Width="154" Height="13" Background="#fff" />
		<NodeUnit Type="TextBlock" Top="16" Left="3" Width="154" Height="14" Background="#F9F9F9" />
		<NodeUnit Type="TextBlock" Binding="ORG_NM" Top="3" Left="3" Width="154" Height="27" BorderThickness="1" BorderBrush="#cccccc" VerticalAlignment="Center" Background="#CC99CC" FontSize="11" FontFamily="돋움" FontBold= "True" Foreground="#666"/>
		<NodeUnit Type="Image" Src="" Top="8" Left="119" Width="16" Height="16"  />
		<NodeUnit Type="Image" Binding="PHOTO" Top="32" Left="3" Width="60" Height="83" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="32" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="49" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="66" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직책:" Top="83" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="입사:" Top="100" Left="65" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="32" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="49" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="66" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKCHAK_NM" Top="83" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="EMP_YMD" Top="100" Left="92" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
	  </NodeDesign>
<!-- ==================================design4(트리조건 '소속+사원+사진', '소속+사원+사진+리스트' 으로 검색시 적용되는 디자인)================================== -->

<!-- ==================================design5================================== -->
	  <NodeDesign Name="design5" Width="86" Height="118" BorderThickness="1" BorderBrush="#cccccc" Background="#F9F9F9" >
		<NodeUnit Type="Image" Binding="PHOTO" Top="3" Left="3" Width="80" Height="73" Background="#fff" BorderThickness="1" BorderBrush="#cccccc" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="성명:" Top="82" Left="5" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="사번:" Top="96" Left="5" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Text="직위:" Top="110" Left="5" Width="50" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#999" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="NAME" Top="82" Left="35" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="SABUN" Top="96" Left="35" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
		<NodeUnit Type="TextBlock" Binding="JIKWEE_NM" Top="110" Left="35" Width="70" Height="17" HorizontalAlignment="Left" Background="Transparent" FontSize="11" FontFamily="돋움" Foreground="#666" UseHandCursor="true"/>
<!-- ==================================design5================================== -->
	  </NodeDesign>
