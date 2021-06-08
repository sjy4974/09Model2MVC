<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
	   	
		$("form").attr("method","POST").attr("action","/purchase/listPurchase?");
	}
	
	$(function(){
		
		$ (".ct_list_pop td:nth-child(1)").on("click", function(){
			
			var tranNo = $(this).find('input').val();
			
			self.location = "/purchase/getPurchase?tranNo="+tranNo
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
		$("h6").css("color" , "red");
		
		
		$ (".ct_list_pop td:nth-child(3)").on("click", function(){
			
			self.location = "/user/getUser?userId="+$(this).text().trim();
		});
		
		$( ".ct_list_pop td:nth-child(5)" ).css("color" , "blue");
		$("h4").css("color" , "blue");
		
		$ (".ct_list_pop td:contains('물건도착')").on("click", function(){
			
			var tranNo = $(this).find('input').val();
			
			self.location = "/purchase/updateTranCode?tranNo="+tranNo+"&tranCode=3&page="+${search.currentPage}
		});
	});
	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11" >
			전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">
			회원ID
			<h6>(회원ID click:상세정보)</h6>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">
			상품명
			<h4>(상품명 click:상세정보)</h4>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">전화번호</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	
	<c:set var="i" value="0" />
	<c:forEach var="purchase" items="${list}">
		<c:set var="i" value="${ i+1 }" />
	<tr class="ct_list_pop">
		<td align="center">
			<!-- <a href="/purchase/getPurchase?tranNo=${purchase.tranNo}">${i}</a> -->
			${i}<input type="hidden" value="${purchase.tranNo}">
		</td>
		<td></td>
		<td align="left">
			<!-- <a href="/user/getUser?userId=${purchase.buyer.userId}">${purchase.buyer.userId}</a> -->
			${purchase.buyer.userId}
		</td>
		<td></td>
		<td align="left">${purchase.purchaseProd.prodName}</td>
		<td></td>
		<td align="left">${purchase.receiverPhone}</td>
		<td></td>
		<td align="left">
			<c:choose>
				<c:when test= "${purchase.tranCode == '1  ' }">
					구매완료
				</c:when>
				<c:when test= "${purchase.tranCode == '2  ' }">
					배송중 
				</c:when>
				<c:when test= "${purchase.tranCode == '3  ' }">
					배송완료
				</c:when>
			</c:choose>
		</td>
		
		<td></td>
		<td align="left">
			<c:if test="${purchase.tranCode == '2  ' }">
				<!-- <a href="/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3&page=${search.currentPage}">물건도착</a> -->
				물건도착<input type="hidden" value="${purchase.tranNo}">
			</c:if>
		</td>
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