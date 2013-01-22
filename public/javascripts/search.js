function checkTime(){
    var now = new Date();
    var dateString = (now.getMonth()+1).toString() + " " + now.getDate().toString() + "," + now.getFullYear().toString();
    var amLate = new Date(Date.parse(dateString + " 07:50:00"));
    var amLeaveSchool = new Date(Date.parse(dateString + " 11:55:00"));
    var pmLate = new Date(Date.parse(dateString + " 14:30:00"));
    var pmLeaveSchool = new Date(Date.parse(dateString + " 17:00:00"));

    if((now > amLate) && (now < amLeaveSchool)){
        jQuery('#v1').attr('checked',true);
    }
    else if((now > pmLate) && (now < pmLeaveSchool)){
        jQuery('#v1').attr('checked',true);
    }
    else{
        jQuery('#v1').attr('checked',false);
    }
}

function domo(){

    jQuery(document).bind('keydown', 'f1',
        function (evt){
            var curValue = $("#v1").attr("checked");
            jQuery('.late-reason').attr('checked',false);
            $("#v1").attr("checked",!curValue);
            return false;
        });

    jQuery(document).bind('keydown', 'f2',function (evt){
        var curValue = $("#v2").attr("checked");
        jQuery('.late-reason').attr('checked',false);
        $("#v2").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f3',function (evt){
        var curValue = $("#v3").attr("checked");
        jQuery('.late-reason').attr('checked',false);
        $("#v3").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f4',function (evt){
        var curValue = $("#v4").attr("checked");
        jQuery('.late-reason').attr('checked',false);
        $("#v4").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f5',function (evt){
        var curValue = $("#v5").attr("checked");
        jQuery('.late-reason').attr('checked',false);
        $("#v5").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f6',function (evt){
        var curValue = $("#v6").attr("checked");
        $("#v6").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f7',function (evt){
        var curValue = $("#v7").attr("checked");
        $("#v7").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f8',function (evt){
        var curValue = $("#v8").attr("checked");
        $("#v8").attr("checked",!curValue);
        return false;
    });
    jQuery(document).bind('keydown', 'f9',function (evt){
        var curValue = $("#v9").attr("checked");
        $("#v9").attr("checked",!curValue);
        return false;
    });
    jQuery(document).bind('keydown', 'f11',function (evt){
        var curValue = $("#v11").attr("checked");
        $("#v11").attr("checked",!curValue);
        return false;
    });
    jQuery(document).bind('keydown', 'f10',function (evt){
        var curValue = $("#v10").attr("checked");
        $("#v10").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f11',function (evt){
        var curValue = $("#v11").attr("checked");
        $("#v11").attr("checked",!curValue);
        return false;
    });

    jQuery(document).bind('keydown', 'f12',function (evt){
        var curValue = $("#v16").attr("checked");
        $("#v16").attr("checked",!curValue);
        return false;
    });

}

function monitorKeyword(){
    reg=/^\d{8}$|^[\u4E00-\u9FA5]{3,4}$/;
    var keyword = $.trim($("#keyword").val())
    if(!reg.test(keyword)){
    //        $("#index-tips").fadeIn("slow");
    //        $("#index-tips").html("请输入正确的学号或者学生姓名。");
    }else{
        window.location.href = "/home/search/?keyword=" + keyword;
    }
}

function dormitoryKeyword(){
    reg=/^\d{8}$|^[\u4E00-\u9FA5]{3,4}$/;
    var keyword = $.trim($("#keyword").val())
    if(!reg.test(keyword)){
    //        $("#index-tips").fadeIn("slow");
    //        $("#index-tips").html("请输入正确的学号或者学生姓名。");
    }else{
        window.location.href = "/home/dormitory_search/?keyword=" + keyword;
    }
}

function clearOther(cur){
    var curCheck = cur.checked;
    jQuery('.late-reason').attr('checked',false);
    cur.checked=curCheck;
}

function checkv11(cur){
    var curValue = cur.value;
    if (curValue == 15){
        jQuery('#v11_wrapper').show();
    }else{
        jQuery('#v11_wrapper').hide();
    }
}
