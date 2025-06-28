<?php

//аунтификация админа и других привелигированных пользователей

class Auth extends Controller
{
    public static function checkUser()
    {
        if (isset($_POST['login']) && isset($_POST['position']) && isset($_POST['code'])) {
            if (
                $_POST['login'] == "Христофоров Руслан Васильевич"
                && $_POST['position'] == "администратор" && $_POST['code'] == "123"
                && isset($_POST['doGoR'])
            ) {
                //echo "<a class='refer' href='./menu'>Войти в систему</a>";
                echo '<script>window.location.href = "./menu";</script>';
                //echo "<div onclick=location.href='./employee>";
            } else {
                echo "<dir class='acces'> Неправильно введенные данные! </dir>";
            }
        }
    }
}
