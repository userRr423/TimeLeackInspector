<!DOCTYPE html>

<?php

$name = "не определено";
if (isset($_GET["name"])) {

    $name = $_GET["name"];
}

if (isset($_GET["surname"])) {

    $surname = $_GET["surname"];
}

if (isset($_GET["middle_name"])) {

    $middle_name = $_GET["middle_name"];
}
//получение выбранного сотрудника на панели

//получение кода даступа в строковом режиме для выбора нужного файла
Employee::GetCodeStr($middle_name, $surname, $name);
$key = Employee::$Monitoringfile;


?>



<head>
    <title>Информация о сотруднике</title>
    <meta charset="utf-8">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

    <style>
        <?php include "./static/css/style.css" ?>
    </style>

    <script>
        //выбор нужного файла
        let file = "<?php echo $key; ?>"

        let s1, s2;

        console.log(file);

        function check() {
            if (window.s2 <= window.s1) {
                console.log("Онлайн");
            } else {
                console.log("не в сети");
            }
        }

        function timePrev() {
            $.ajax({
                type: "GET",
                url: "../upload/work_time" + file + ".json",
                success: function(response) {

                    response.seconds = window.s2;
                }
            });
        }

        function ajaxCall() {
            //файлы мониторинга которые отсылает клиент

            $.ajax({
                type: "GET",
                url: "../upload/online" + file + ".json",
                success: function(response) {

                    $(".monitoring-panel .online").html("<b>online:</b>" + response.online);

                }
            });

            $.ajax({
                type: "GET",
                url: "../upload/work_time" + file + ".json",
                success: function(response) {

                    $(".monitoring-panel .time").html("<b>Часы:</b>" + response.hours + " <br>" +
                        "<b>Минуты:</b> " + response.minutes + " <br>" +
                        "<b>Секунды:</b> " + response.seconds + " <br>"
                    );
                    response.seconds = window.s2;
                    //console.log(response);
                }
            });

            $.ajax({
                type: "GET",
                url: "../upload/AppsView" + file + ".json",
                success: function(response) {

                    $(".monitoring-panel .apps").html("<b>Открытые приложения:</b>" + response.apps + " <br>" +
                        "<b>количество:</b> " + response.count + " <br>" +
                        "<b>активное приложение:</b> " + response.activeApp + " <br>"
                    );
                    //console.log(response);

                }
            });

            $.ajax({
                type: "GET",
                url: "../upload/keybord_and_mouse" + file + ".json",
                success: function(response) {

                    $(".monitoring-panel .keyboard").html("<b>ПозицияX:</b>" + response.mouseX + "<br>" +
                        "<b>ПозицияY:</b>" + response.mouseY + "<br>" +
                        "<b>Язык:</b>" + response.language + "<br>" +

                        "<b>Прокрутка вверх:</b>" + response.scrollUp + "<br>" +
                        "<b>Прокрутка вниз:</b>" + response.scrollDown + "<br>" +
                        "<b>Левый клик:</b>" + response.Left + "<br>" +
                        "<b>Правый клик:</b>" + response.Right + "<br>" +
                        "<b>Нажатые клавиши:</b>" + response.key + "<br>"
                    );
                    //console.log(response);

                }
            });



        }

        setInterval(ajaxCall, 1000);
        setInterval(timePrev, 2000);

        setInterval(check, 3000);
    </script>


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
                <div onclick="location.href='./menu';" class="choose-row">
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

            <div class="panel-app">
                <div class="about-employee">
                    <img class="l-empl" src="./static/image/l-employee.png" alt="" width="30" height="30">
                    О сотруднике
                </div>

                <div class="monitoring">
                    <img class="l-p" src="./static/image/puls.gif" alt="" width="40" height="40">
                    Активность
                </div>
            </div>

            <div class="employee-info-panel">
                <?php //Menu::EmployeesList('employee');
                Employee::showInfo('employee-info', $name, $surname, $middle_name);
                ?>
            </div>


            <div class="monitoring-panel">
                <div class="online">

                </div>

                <div class="time">

                </div>

                <div class="apps">

                </div>

                <div class="keyboard">

                </div>

            </div>

            <div class="monitoring-panel2">


            </div>
            <?php
            echo Employee::$Monitoringfile;

            ?>
        </div>
    </div>

    <script src="./static/js/employeePanel.js"></script>
    <script src="./static/js/sideBar.js"></script>
</body>