<!DOCTYPE html>


<head>
    <title>Главное меню</title>
    <meta charset="utf-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

    <style>
        <?php include "./static/css/style.css" ?>
    </style>





</head>

<body>

    <div class="head">
        <img class="logo-img-menu" src="./static/image/logo.png" alt="" width="140" height="40">
        <div class="exit">
            <img src="./static/image/exit.png" alt="" width="45px" height="40px">
        </div>
    </div>

    <div class="container">

        <div class="side-container">

            <div id="choose-organizations" class="choose-item">
                <p>Организации</p>
                <img id="one" class="choose-img" src="./static/image/hid.png" alt="" width="20px" height="20px">
            </div>

            <div id="organizations" class="sideBar">
                <div class="choose-row last">
                    <img src="./static/image/or.png" alt="" width="35px" height="35px">
                    <p>Петргу</p>
                </div>
            </div>

            <div id="main-choose" class="choose-item">
                <p>Основное</p>
                <img id="two" class="choose-img" src="./static/image/hid.png" alt="" width="20px" height="20px">
            </div>
            <div id="main-functional" class="sideBar">
                <div class="choose-row">
                    <img src="./static/image/list.png" alt="" width="35px" height="35px">
                    <p>Список сотрудников</p>
                </div>

                <div class="choose-row">
                    <img src="./static/image/info.png" alt="" width="35px" height="35px">
                    <p>Журнал событий системы</p>
                </div>

                <div class="choose-row">
                    <img src="./static/image/grup.png" alt="" width="35px" height="35px">
                    <p>Подразделения</p>
                </div>


                <div class="choose-row">
                    <img src="./static/image/add.png" alt="" width="35px" height="35px">
                    <p>Добавить сотрудника</p>
                </div>

                <div class="choose-row">
                    <img src="./static/image/plan.png" alt="" width="35px" height="35px">
                    <p>График работы</p>
                </div>

                <div class="choose-row">
                    <img src="./static/image/er.png" alt="" width="35px" height="35px">
                    <p>Отсутствие на работе</p>
                </div>

                <div class="choose-row last">
                    <img src="./static/image/set.png" alt="" width="35px" height="35px">
                    <p>Настройки системы</p>
                </div>

            </div>

            <div id="choose-directorys" class="choose-item">
                <p>Справочники</p>
                <img id="three" class="choose-img" src="./static/image/hid.png" alt="" width="20px" height="20px">
            </div>

            <div id="directorys" class="sideBar">
                <div class="choose-row">
                    <img src="./static/image/sp.png" alt="" width="35px" height="35px">
                    <p>Рабочий график</p>
                </div>

                <div class="choose-row last">
                    <img src="./static/image/sp.png" alt="" width="35px" height="35px">
                    <p>График отпусков</p>
                </div>
            </div>

        </div>


        <div class="main">

            <div class="panel">

            </div>

            <div class="container-employee">

                <div class="employee-container">
                    <?php Menu::EmployeesList('employee');
                    //print_r(Menu::$arrlist) 
                    ?>
                </div>


                <div class="online-employee-container">
                    <div class="online-employee">

                    </div>

                    <div class="online-employee-not ">

                    </div>
                </div>


            </div>


        </div>



        <script>
            let arrJs = "<?php echo json_encode(Menu::$arrlist) ?>"

            let a = JSON.parse(arrJs);


            function ajaxCall() {

                $(".online-employee").empty();
                $(".online-employee-not").empty();
                for (let i = 0; i < a.length; i++) {
                    let strA = a[i].toString();
                    console.log(strA);
                    $.ajax({
                        type: "GET",
                        url: "../upload/online" + strA + ".json",
                        success: function(response) {

                            if (response.online == true)
                                $(".online-employee").append("<b>online</b> <br>");
                            else {
                                $(".online-employee-not ").append("<b>не в сети:</b>");
                            }
                        }
                    });
                }

            }

            setInterval(ajaxCall, 1000);
        </script>



    </div>
    <script src="./static/js/sideBar.js"></script>
</body>