let empbutton = document.querySelector("#emplistprp");
List = {}
playerid = undefined
UserActivities = []
window.addEventListener('message', function(event) {
    if (event.data.message == "open") {
        List = event.data.data 
        playerid = event.data.localid
        $("#main").fadeIn(300)
        SetCompanyMoney(event.data.companymoney, event.data.userdata.job, event.data.userdata.joblabel)
        $(".cardlogo").html(`
            <img src="./img/`+event.data.userdata.job+`.png" alt="" style="background-size: 100% 100%;">
        `)
        SetUserData(event.data.userdata)
    } else if (event.data.message == "refresh") {
        SetCompanyMoney(event.data.money)
    } else if (event.data.message == "setlastactiv") {
        SetLastActivities(event.data.type, event.data.amount)
    }
    EmployeeList()
});

EmployeeList = function() {
    $(".mbprp").html("")
    $(".mbprp2").html("")
    onlinePlayers = 0
    Players = List.length
    $.each(List, function(index, value){
        if (value.status) {

            onlinePlayers = onlinePlayers+1
            $(".mbprp").append(`
            <div class="flex justify-between w-full h-[10%] mt-2" style=" background-image: url(./img/listbg.png); background-size: 100% 100%; background-repeat: no-repeat;">
                <div class="flex justify-end items-center  w-[14%] leftname">
                    <div class="flex flex-col w-[68%] h-[60%] lnprp">
                        <h1 style="font-size: .5vw; letter-spacing: .03vw; color: #969FB5;">`+value.jobdata.grade.name+`</h1>
                        <h1 style="font-size: .6vw; color: white;">`+value.charname+`</h1>
                    </div>
                </div>
                <div class="flex justify-center items-end w-[79%] steamname">
                 <div class="flex items-start w-[98%] h-[50%] snprp">
                    <h1 style="font-size: .5vw; color: rgba(255, 255, 255, 0.28);;">[`+value.steam+`]</h1>
                </div>
                </div>
                <div class="flex justify-start items-center w-[7%] status">
                 <div class="flex justify-start items-center w-full h-[40%] statusprp" >
                    <li style=" width: 20%; font-size: .84vw; color: greenyellow;"></li> <span style="color: white; font-size: .55vw; color: #CCFFB5;;">ONLINE</span>
                </div>
            
                </div>
            </div>
            `)
            $(".mbprp2").append(`
            <div class="flex justify-between w-full h-[12%] list1 mt-2" style=" background-image: url(./img/listbg.png); background-size: 100% 100%; background-repeat: no-repeat;">
                                        <div class="flex justify-end items-center  w-[25%] leftname" >
                    <div class="flex flex-col w-[68%] h-[60%] lnprp">
                        <h1 style="font-size: .5vw; letter-spacing: .03vw; color: #969FB5;">`+value.jobdata.grade.name+`</h1>
                        <h1 style="font-size: .6vw; color: white;">`+value.charname+`</h1>
                    </div>
                </div>
                <div class="flex justify-center items-end w-[50%] steamname" >
                 <div class="flex items-start w-[98%] h-[50%] snprp">
                    <h1 style="font-size: .5vw; color: rgba(255, 255, 255, 0.28);;">[`+value.steam+`]</h1>
                </div>
                </div>
                <div class="flex justify-center items-center recruit h-[100%] w-[12%]" >
                    <div class="flex justify-center items-center uprank h-full w-1/3">
                      <div class="flex justify-center items-center itemlist uprankprp w-4 h-4" style="cursor: pointer;" value="uprank" id=`+value.playerid+` ">
                        <img src="./img/uprank.png" alt="" style="background-size: 100% 100%;">
                    </div>
                    </div>
                    <div class="flex justify-center items-center uprank h-full w-1/3" >
                        <div class="flex justify-center items-center itemlist decruit w-4 h-4" style="cursor: pointer;" value="decruit" id=`+value.playerid+` " >
                          <img src="./img/decruit.png" alt="" style="background-size: 100% 100%;">
                      </div>
                      </div>
                      <div class="flex justify-center items-center uprank h-full w-1/3">
                        <div class="flex justify-center items-center itemlist downrank w-4 h-4" style="cursor: pointer;" value="downrank" id=`+value.playerid+` ">
                          <img src="./img/downrank.png" alt="" style="background-size: 100% 100%;">
                      </div>
                      </div>
                </div>
                <div class="flex justify-start items-center w-[20%] status">
                    <div class="flex justify-start items-center w-full h-[40%] statusprp" >
                        <li style=" width: 20%; font-size: .84vw; color: greenyellow; margin-bottom: .1vw;"></li> <span style="color: white; font-size: .55vw; color: #CCFFB5;;">ONLINE</span>
                    </div>
                </div>



                </div>
            `)
        } else {
            $(".mbprp").append(`
            <div class="flex justify-between w-full h-[10%] list2 mt-2" style=" background-image: url(./img/listbg.png); background-size: 100% 100%;">
            <div class="flex justify-end items-center  w-[14%] leftname">
                <div class="flex flex-col w-[68%] h-[60%] lnprp">
                    <h1 style="font-size: .5vw; letter-spacing: .03vw; color: #969FB5;">`+value.jobdata.grade.name+`</h1>
                    <h1 style="font-size: .6vw; color: white;">`+value.charname+`</h1>
                </div>
            </div>
            <div class="flex justify-center items-end w-[79%] steamname">
             <div class="flex items-start w-[98%] h-[50%] snprp">
                <h1 style="font-size: .5vw; color: rgba(255, 255, 255, 0.28);;">[`+value.steam+`]</h1>
            </div>
            </div>
            <div class="flex justify-start items-center w-[7%] status">
             <div class="flex justify-start items-center w-full h-[40%] statusprp">
                <li style=" width: 20%; font-size: .84vw; color:  #FF8282;"></li> <span style=" font-size: .55vw; color: #FFB1B1;">OFFLINE</span>
            </div>
        
            </div>
        </div>
            `)
        }
    })

    $(".numberprp").html(`
        <h1 style="color: #CCFFB5; font-size: .9vw;">`+onlinePlayers+`</h1><span style="color: rgba(255, 255, 255, 0.46); font-size: .5vw;" >/`+Players+`</span>
    `)
}


function empac(){
    document.querySelector(".mainprp").style.display = "block";
    document.querySelector("#companymenu").style.display = "none";
    document.querySelector("#recruitmenu").style.display = "none";
    document.querySelector("#recruitbtn").style.backgroundImage = "url('./img/btnbg.png')";
    document.querySelector("#emplistbtn").style.backgroundImage = "url('./img/btnactive.png')";
    document.querySelector("#cmpbtn").style.backgroundImage = "url('./img/btnbg.png')";
}

function recac(){
    document.querySelector(".mainprp").style.display = "none";
    document.querySelector("#companymenu").style.display = "none";
    document.querySelector("#recruitmenu").style.display = "flex";
    document.querySelector("#recruitbtn").style.backgroundImage = "url('./img/btnactive.png')";
    document.querySelector("#emplistbtn").style.backgroundImage = "url('./img/btnbg.png')";
    document.querySelector("#cmpbtn").style.backgroundImage = "url('./img/btnbg.png')";
}

function compac(){
    document.querySelector(".mainprp").style.display = "none";
    document.querySelector("#companymenu").style.display = "block";
    document.querySelector("#recruitmenu").style.display = "none";
    document.querySelector("#recruitbtn").style.backgroundImage = "url('./img/btnbg.png')";
    document.querySelector("#emplistbtn").style.backgroundImage = "url('./img/btnbg.png')";
    document.querySelector("#cmpbtn").style.backgroundImage = "url('./img/btnactive.png')";
}

openInventory = function() {
    $("#main").fadeOut(300)
    $.post("https://cdm-xboss/OpenInventory", JSON.stringify({}));
}


$(document).on("click", ".itemlist", function (e) { 
    $.post('https://cdm-xboss/updatejob', JSON.stringify({
            value : $(this).attr("value"),
            playerid : $(this).attr("id")
    }));
})

Deposit = function(val) {
    if (val) {
        $.post('https://cdm-xboss/deposit', JSON.stringify({
            amount : Number(val)
        }));
    } else {
        val = $(".inputcont").val()
        $.post('https://cdm-xboss/deposit', JSON.stringify({
            amount : Number(val)
        }));
    }
}

Withdraw = function(val) {
    if (val) {
        $.post('https://cdm-xboss/withdraw', JSON.stringify({
            amount : Number(val)
        }));
    } else {
        val = $(".inputcont").val()
        $.post('https://cdm-xboss/withdraw', JSON.stringify({
            amount : Number(val)
        }));
    }
}

SetCompanyMoney = function(amount, job, joblabel) {
    $(".jobnamexd").html(joblabel)
    $(".caprpmoney").html('<h1 style="font-size: 1vw;">$'+amount+'</h1>')
}

openOutfit = function() {
    $("#main").fadeOut(300)
    $.post('https://cdm-xboss/OpenOutfit', JSON.stringify({
            
    }));
}

setJob = function() {
    var id = $(".playerId").val()
    $.post('https://cdm-xboss/setjob', JSON.stringify({
        id : id
    }));
}

SetLastActivities = function(type, amount) {
    if(type == "deposit") {
        $(".overflow-menu").prepend(`
        <div class="flex justify-center items-center mt-2 actwithdraw w-full h-[20%] " style=" background-image: url(./img/actbg.png); background-size: 100% 100%;">
            <div class="flex justify-between items-center w-[86%] h-[37%] acttextprp" >
                <div class="flex w-[20%] justify-start items-center h-full actwithdraw" >
                    <h1 class="upper"  style="font-size: .6vw;" >DEPOSIT</h1>
                </div>
                <div class="flex w-[60%] justify-end items-center h-full actwithdrawval" >
                    <h1 style="font-size: .6vw; color: #FF7B7B; letter-spacing: .1vw; ">-$`+amount+`</h1>
                </div>
            </div>
        </div>
    `)
    } else {
        $(".overflow-menu").prepend(`
        <div class="flex justify-center items-center mt-2 actwithdraw w-full h-[20%] " style=" background-image: url(./img/actbg.png); background-size: 100% 100%;">
                                                    <div class="flex justify-between items-center w-[86%] h-[37%] acttextprp" >
                                                        <div class="flex w-[20%] justify-start items-center h-full actwithdraw" >
                                                            <h1  style="font-size: .6vw;" >WITHDRAW</h1>
                                                        </div>
                                                        <div class="flex w-[60%] justify-end items-center h-full actwithdrawval" >
                                                            <h1 style="font-size: .6vw; color: #D1FFAC;; letter-spacing: .1vw; ">+$`+amount+`</h1>
                                                        </div>
                                                    </div>
                                                </div>
        `)
    }
    
}

SetUserData = function(data) {
    $(".pphotoprp").html('<img src="'+data.image+'" alt="" style="background-size: 100% 100%; background-repeat: no-repeat; border-radius:2vw;">')
    $(".ptextprp").html(`
    <h1 style="font-size: .4vw; color: #707788;">`+data.joblabel+`</h1>
    <h1 style="font-size: .5vw;">`+data.fullname+`</h1>
    `)

}


$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
        $("#main").fadeOut(300)
            $.post("https://cdm-xboss/CloseUi", JSON.stringify({}));
            break;
        case 113: // ESC
        $("#main").fadeOut(300)
        $.post("https://cdm-xboss/CloseUi", JSON.stringify({}));
            break;
    }
});