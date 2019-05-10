<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
.restaurantTopInput {
   width: 400px;
   height: 60px;
   font-size: 25px;
}

.restaurantInput {
   width: 300px;
   height: 40px;
}

#field div {
   float: left;
   margin: 10px;
   width: 498px;
}

#field input {
   height: 40px;
   font-size: 1.3em;
   outline: none;
   display: inline;
}

#field input[type="text"] {
   box-sizing: border-box;
   color: black;
}

#field  input[type=button] {
   padding-bottom: 3px;
   margin-left: -2px;
}

#field  div:nth-child(2n+1) {
   clear: left;
}

ul {
   list-style: none;
   padding-left: 0px;
}

input[type=button]:hover, input[type=submit]:hover, button:hover {
   color: #FFD9EC;
   background-color: #5D5D5D;
}
</style>
<title>Insert title here</title>

<script type="text/javascript" 
   src="/uDongMat/resources/js/jquery-3.3.1.js"></script>
   
<script type="text/javascript">

   function numberWithCommas(x) {
       return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
   }
   
   function comma(num){
       var len, point, str; 
          
       num = num + ""; 
       point = num.length % 3 ;
       len = num.length; 
      
       str = num.substring(0, point); 
       while (point < len) { 
           if (str != "") str += ","; 
           str += num.substring(point, point + 3); 
           point += 3; 
       } 
        
       return str;
    
   }

   $(function() {
     var $input = $(".input");
     $input.on('blur', function() {
       // 입력 값 알아내기
       var _$self = $(this);
       var value = _$self.val();

       // 원단위로 변경하기
       var result = AddComma(value);

       _$self.val(result);
     })

   });

   function AddComma(dataValue) {
     isNumber(dataValue);
     var separateValue = Number(dataValue).toLocaleString('en');
     if (separateValue == 'NaN') {
       return '';
     }
     return separateValue;
   }


   function moveToListFnc(restaurantNo) {
      var url = 'list.do?restaurantNo=' + restaurantNo;
      location.href = url;
   }
   
   function moveToUpdateFnc(restaurantNo) {
      var url = 'update.do?restaurantNo=' + restaurantNo;
      location.href = url;
   }
   
   function moveTodeleteCtrFnc(restaurantNo) {
      var url = 'deleteCtr.do?restaurantNo=' + restaurantNo;
      location.href = url;
   }
   
</script>
</head>
<body>
   <div style="width: 1920px;">

      <jsp:include page="/WEB-INF/views/headerTitle.jsp" />
      <jsp:include page="/WEB-INF/views/headerButtons.jsp" />

      <div style="margin-left: 450px;">
         <form action="./update.do" method="get">
            <div style="width: 1050px; height: 480px; padding: 20px; border: 1px solid black">
               <div style="width: 600px; height: 480px; border: 1px solid black; float: left;">
                  <div id="fileContent">
                     <div>
                        <c:forEach var="row" items="${fileList}" varStatus="obj">
                           <input type="hidden" id="fileIdx_${obj.index}" name="fileIdx" value="${row.IDX}">
                           <img alt="image not found" style="width: 600px; height: 480px;"
                              src="<c:url value='/img/${row.STORED_FILE_NAME}'/>" />
                        </c:forEach>
                     </div>
                  </div>
               </div>

               <input type="hidden" name='restaurantNo' value='${restaurantsVo.restaurantNo}'>

               <div style="width: 400px; height: 440px; padding: 20px; border: 1px solid black; float: left;">
                  <ul>
                     <li><input type="text" name='restaurantName' class="restaurantTopInput"
                        value='${restaurantsVo.restaurantName}' readonly="readonly">
                  </ul>
                  <ul>
                     <li><input type="text" name='category' class="restaurantTopInput" value='${restaurantsVo.category}'
                        readonly="readonly">
                  </ul>
                  <ul>
                     <li><input type="text" name='phone' class="restaurantTopInput" value='${restaurantsVo.phone}'
                        readonly="readonly">
                  </ul>
                  <ul>
                     <li><input type="text" name='operatingTime' class="restaurantTopInput"
                        value='${restaurantsVo.operatingTime}~${restaurantsVo.closingTime}' readonly="readonly">
                  </ul>
                  <ul>
                     <li><textarea style="width: 400px; height: 100px; resize: none;" readonly="readonly" name="address">
                     ${restaurantsVo.address}</textarea>
                  </ul>
               </div>
            
            </div>
            <div style="width: 1050px; padding: 20px; border: 1px solid black; margin-top: 20px;">
               <span style="font-size: 30px; font-weight: bold;">맛집소개</span>
               <textarea style="width: 1040px; height: 200px; resize: none; margin-top: 10px; margin-bottom: 20px;"
                name="contents" readonly="readonly">${restaurantsVo.contents}</textarea>
               <span style="font-size: 30px; font-weight: bold;">메뉴</span>
               <div id="field">
                  <c:forEach var="menusVo" items="${menusList}">
                     
                     <div>
                        <input type="text" name='"menuName"' style="width: 280px;" value='${menusVo.menuName}'
                         readonly="readonly">
                        <input type="text" name='price' id="input" style="text-align:right; width: 180px; padding-top: 5px; margin-left: -6px;"
                         value="<fmt:formatNumber pattern="#,###원" value="${menusVo.price}"/>" readonly="readonly">
                     </div>
                  </c:forEach>
               </div>
               
               <div style="clear: left;"></div>

            </div>
            <div style="width: 1095px; text-align: center; margin-top: 20px;">
               <input type="button" value="이전화면" class="restaurantInput" onclick="moveToListFnc(${restaurantsVo.restaurantNo});">
               <input type="button" value="수정" style="margin-left: 91px; margin-right: 91px;" class="restaurantInput"
                  onclick="moveToUpdateFnc(${restaurantsVo.restaurantNo});">
               <input type="button" value="삭제" class="restaurantInput" onclick="moveTodeleteCtrFnc(${restaurantsVo.restaurantNo});">
            </div>
         </form>
      </div>
      <jsp:include page="/WEB-INF/views/Tail.jsp" />
   </div>
</body>
</html>