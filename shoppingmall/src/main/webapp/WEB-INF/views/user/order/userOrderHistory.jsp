<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.88.1">
    <title>PsaMall</title>


    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
    </style>

    
    <!-- Custom styles for this template -->
    <link href="/css/album.css" rel="stylesheet">
    
    <!-- bootstrap 버전 및 여러 파일들 -->
	<%@include file="/WEB-INF/views/include/common.jsp" %>
  </head>
  <body>
    
<header>
	<%@include file="/WEB-INF/views/include/header.jsp" %>
</header>

<main role="main" style="margin-top: 75px">

  <section class="jumbotron text-center">
    <div class="container">
      <h1>주문내역</h1>
    </div>
  </section>

 <div class="container">
		<div class="row">
	      	<div class="col-md-12">      	
	      		<div class="box box-primary">
	      			<div class="box-header">
	      				<h5>ORDER HISTORY</h5>    
	      			</div>	
	      			<div class="box-body">	
					  <form action="/user/order/userOrderList" method="get" id="productSelectedForm">    
					  	<c:forEach items="${orderHistory}" var="orderHistory" varStatus="status">
					  		<hr>
					  		<p><fmt:formatDate value="${orderHistory.ORD_DATE}" pattern="yyyy-MM-dd hh:mm:ss"/></p>  
				  			<div class="row">          
						       	<div class = "col-4">
						  			<!-- 상품 이미지 -->
						      		<a class="move" href="${orderHistory.P_NUM}">
							      		<img src="/user/order/displayFile?folderName=${orderHistory.P_IMAGE_FOLDER}&fileName=s_${orderHistory.P_IMAGE}" 
							      		alt="" style="width: 80px; height: 80px" onerror="this.onerror=null; this.src='/image/no_image.png'">
							      	</a>
						      	</div>
						      	<div class = "col-4">
						      		<!-- 상품 정보 -->
						      		<p>${orderHistory.P_NAME}</p>
						      		<p>
						      			판매가격: <fmt:formatNumber type="number" maxFractionDigits="3" value="${orderHistory.P_COST}" />
						      			(${orderHistory.ORD_AMOUNT}개)
						      		</p>
						      	</div>
						      	<div class = "col-2">
						      		<!-- 주문 상태 -->
						      		<p> ${orderHistory.ORD_STATUS} </p>
						      	</div>
						      	<div class = "col-2">
						      		<!-- 리뷰쓰기 -->
						      		<button type="button" class="btn btn-link" name="bunwriteReview">리뷰 쓰기</button>
						      	</div>
						      </div>
						      
						 
							 </c:forEach>
						</form>								
	      			</div>	
	      		</div>     
	      	</div>      
	      </div>
		</div>
</main>

<footer class="text-muted">
  <%@include file="/WEB-INF/views/include/footer.jsp" %>
</footer>

	<script>

		$(function(){

			totalInfo();
			
			//체크박스 전체선택(제목 행 체크박스)
			$("#checkAll").on("click", function(){
			  
			  $("input[name='checkProduct']").prop("checked", this.checked);
			  //attr()메소드 사용 X
			  
			
			});
			
			//데이터 행 체크박스
			$("input[name='checkProduct']").on("click", function(){
			
			  //데이터 행의 체크박스가 전부 체크되어있다면 전체선택 체크박스도 체크!
			  $("#checkAll").prop("checked", this.checked);
			
			  //데이터 행의 체크박스의 선택자 해당하는 만큼 동작하는 구문
			  $("input[name='checkProduct']").each(function() {
			    if(!$(this).is(":checked")) {
			      //체크가 하나라도 존재
			      $("#checkAll").prop("checked", false);
			    }
			  });
			});

			//선택 여부에 따른 금액 변화
			$("input[name='checkProduct']").on("change", function(){
				// console.log("체크변화");
				totalInfo();
			});

			//장바구니 페이지에서 상품 수량 변경
			$("button[name='btnCartAmountChange']").on("click", function(){
				console.log("수량 변경 버튼 클릭");

				let btnCartAmountChange = $(this);

				let cart_code = $(this).data("cart_code");
				let cart_amount = $(this).parent().find("input[name='cart_amount']").val();

				$.ajax({
					url: '/user/cart/changeCartAmount',
					data: {cart_code : cart_code, cart_amount : cart_amount},
					dataType: 'text',
					success: function(result) {
						if(result == "success") {
							alert("선택하신 상품의 수량이 변경되었습니다.");
							
							//개별 상품 금액 변경
							//상품 가격 참조
							let p_cost = btnCartAmountChange.parent().find("input[name='p_cost']").val();
							btnCartAmountChange.parents("tr").find("span.unitPrice").html($.numberWithCommas(p_cost * cart_amount));
							
							//새로고침 안하려고 ajax를 사용했으나 수량 수정 후 총구매금액 변경이 안됨...
							location.href="/user/cart/cartList";

							//총 구매금액 변경
							// let totalPrice = 0;
							/* $("table#tblCartList tr td span.unitPrice").each(function(index, item){
								// console.log("단위가격: " + $(item).html());
								// console.log("단위가격: " + $(item).text());
								
								// totalPrice += parseInt($.withoutCommas($(item).text())); //무언갈 읽어오는 데이터는 전부 text(String)
								// $("table#tblCartList tr td span#cartTotalPrice").text($.numberWithCommas(totalPrice));
							});  */
						}
					}

					
				});

			});

			let productSelectedForm = $("#productSelectedForm");
			
			//선택된 상품 삭제
			$("#btnSelectDelete").on("click", function(){
				console.log("상품삭제");

				if(!confirm("선택하신 상품을 삭제하시겠습니까?")){
					return;
				}

				productSelectedForm.attr("action","/user/cart/deleteCart");
				productSelectedForm.submit();
			});

			//장바구니 비우기
			$("button#btnClearCart").on("click", function(){
				console.log("장바구니 비우기");

				if(!confirm("장바구니를 비우시겠습니까?")){
					return;
				}

				location.href = "/user/cart/clearCart";
			});
			
			//주문하기 버튼 클릭			
 			$("#btnOrder").on("click", function(){
 				console.log("주문하기");
 				
 				let type = "cartOrder";
 				//productSelectedForm.attr("action","/user/order/orderList");
 				productSelectedForm.submit();
			}); 
			
			//선택한 상품 주문하기
 			/*$("button#btnOrder").on("click", function(){
				// console.log("주문하기");
				
				if(!confirm("선택하신 상품을 주문하시겠습니까?")) return;

				//선택한 상품 값 가져오기
				let checkArr = [];
				$("input[name='checkProduct']:checked").each(function(){
					checkArr.push($(this).val());
				}); 
				
				 console.log(checkArr);

				let ordAmountArr = [];
				$(".productAmountForCal").each(function(){
					ordAmountArr.push($(this).val());
				});
				console.log(ordAmountArr);

 				 $.ajax({
					url: '/user/order/orderList',
					type: 'post',
					data: {
						checkArr : checkArr, ordAmountArr : ordAmountArr
					},
					 success: function(result) {
						if(result == "success") {
							alert("주문 페이지로 이동합니다.");
							location.href="/user/order/orderList";
						}
						
					}  
				
				}); 
 			});*/
				
				
				/*
				let pNumStr = "";
				$("input[name='checkProduct']:checked").each(function(index, item){
					pNumStr += "<input type='hidden' name='checkedValue' value='" + $(item).val() + "'>";
				});
					//" + index + "
				
				$("#orderCheckForm").append(pNumStr);
				$("#orderCheckForm").attr("action", "/user/order/orderSelected");
				$("#orderCheckForm").submit();*/
				
				/* let orderInfoStr = "";
				let orderNumber = 0;
				let orderInfoForm = $("#orderInfoForm");
				
				$(".calCheckedProduct").each(function(index, item){
					
					if($(item).find("input[name='checkProduct']").is(":checked") == true) {

						let p_num = $(item).find(".productNum").val();
						let cart_amount = $(item).find(".productAmountForCal").val();

						orderInfoStr += "<input type='hidden' value='" + p_num + "' name='orderProduct[" + orderNumber + "].p_num'>";

						orderInfoStr += "<input type='hidden' value='" + cart_amount + "' name='orderProduct[" + orderNumber + "].cart_amount'>";

						orderNumber += 1;
					}			

				});

				orderInfoForm.html(orderInfoStr);
				orderInfoForm.attr("action", "/user/order/orderSelected");
				orderInfoForm.submit(); });*/

				
			
			
		});

		//숫자값을 천단위 마다 콤마 찍기
		$.numberWithCommas = function(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
		}

		//3자리마다 콤마 제거하기
		$.withoutCommas = function (x) {
			return x.toString().replace(",", '');
		}

		//변경될때마다 초기화
		//선택한 상품의 정보만 계산하기(배송비, 총 가격, 적립금)
		function totalInfo(){

 			let totalCost = 0; //주문할 상품 총 가격
			let deliveryCost = 0; //배송비
			let totalPoint = 0; //상품 주문시 적립될 포인트 
			let realTotalCost = 0; //상품 총 가격 + 배송비
			
			

			//선택된 상품 계산
			$(".calCheckedProduct").each(function(index, item){			
				
				if($(item).find("input[name='checkProduct']").is(":checked") == true) {

					totalCost += parseInt($(item).find(".productTotalPriceForCal").val());
					totalPoint += parseInt($(item).find(".productPointForCal").val());
				} 
								
			});
			

			//배송비
			if(totalCost >= 30000) {
				deliveryCost = 0;
			} else if(totalCost == 0) {
				deliveryCost = 0;
			} else {
				deliveryCost = 3000;
			}

			realTotalCost = totalCost + deliveryCost;

			//선택된 상품 총 금액
			$("#productTotalPrice").text($.numberWithCommas(totalCost));
			//배송비
			$("#deliveryPrice").text($.numberWithCommas(deliveryCost));
			//총 구매 금액
			$("#cartTotalPrice").text($.numberWithCommas(realTotalCost));
		}
	</script>

<!-- bootstrap에 포함되어 있던 스크립트, 없어도 영향이 없어서 주석처리 
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script>window.jQuery || document.write('<script src="/docs/4.6/assets/js/vendor/jquery.slim.min.js"><\/script>')</script>
    --> <!-- <script src="/docs/4.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script> -->


      
  </body>
</html>
