<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	function fncGetList(currentPage) {
		
		$("#currentPage").val(currentPage)
		
	   	$("form").attr("method", "POST").attr("action","/product/listProduct?menu=${menu}").submit();	
	}
	
	$( function(){
		
		
		$( "td_ct_btn01:contains('검색')").on("click", function(){
			
			fncGetList(1);
		});
		
		$( ".ct_list_pop td:nth-child(3)").on("click", function(){
			
			var prodNo = $(this).find('input').val();
			//alert(prodNo);
			
			var menu = location.search.substring(6);
			//alert(menu);
			self.location = "/product/getProduct?prodNo="+prodNo+"&menu="+menu;
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "blue");
		$("h7").css("color" , "blue");
				
		
		$( ".ct_list_pop td:nth-child(9)").on("click", function(){
			
			var prodNo = $(this).find('input').val();
			//alert(prodNo);
			
			self.location = "/purchase/updateTranCodeByProd?prodNo="+prodNo+"&tranCode=2&page="+${search.currentPage}
		});
		
		
	});
	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						
						<c:if test= "${menu == 'manage'}"> 
						상품 관리
						</c:if>
						<c:if test= "${menu == 'search'}"> 
						상품 목록조회
						</c:if>


					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
			</select>
			<input type="text" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
						class="ct_input_g" style="width:200px; height:20px"
						onkeypress="javascript:if(window.event.keyCode==13){fncGetList('1')}" /> 
		</td>
		
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- <a href="javascript:fncGetList('1');">검색</a> -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">

	<tr>
		<td colspan="11" >
			전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">
			상품명<br>
			<h7>(상품명 click:상세정보)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>	
			
	<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center">${i}</td>
			<td></td>
			<td align="left">
			
			<!--  <a href="/product/getProduct?prodNo=${product.prodNo}&menu=${menu}">${product.prodName}</a>-->
			${product.prodName}<input type="hidden" value="${product.prodNo}"/>
			
			</td>
			<td></td>
			<td align="left">${product.price}</td>
			<td></td>
			<td align="left">${product.regDate}</td>
			<td></td>
			
			<c:if test="${menu == 'manage'}">
				<td align="left">
				<c:choose>
					<c:when test= "${product.proTranCode == '1  ' }">
						구매완료 
						<!-- <a href="/product/updateTranCodeByProd?prodNo=${product.prodNo}&tranCode=2&page=${search.currentPage}">배송하기</a> -->
						&nbsp;배송하기<input type="hidden" value="${product.prodNo}">
					</c:when>
					<c:when test= "${product.proTranCode == '2  ' }">
						배송중
					</c:when>
					<c:when test= "${product.proTranCode == '3  ' }">
						배송완료
					</c:when>
					<c:otherwise>
						판매중
					</c:otherwise>
				</c:choose>
				</td>
			</c:if>
			
			<c:if test="${menu == 'search'}">
				<td align="left">
				<c:choose>
					<c:when test= "${product.proTranCode == null }">
						판매중
					</c:when>
					<c:otherwise>
						재고없음
					</c:otherwise>
				</c:choose>
				</td>
			</c:if>
		
		</tr>
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>

<!-- PageNavigation Start... -->
<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="currentPage" name="currentPage" value=""/>
		
			<jsp:include page="../common/pageNavigator.jsp"/>	
		
    	</td>
	</tr>
</table>
<!-- PageNavigation End... -->

</form>

</div>
</body>
</html>
