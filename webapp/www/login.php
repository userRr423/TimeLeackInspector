<form method="post">
    <p> Логин: <input type="text" name="login" value="<?php
                                                        if (isset($_POST['login']))
                                                            echo $_POST['login']; ?>"> <samp style="color:black">*</samp></p>
    <p> Пароль: <input type="password" name="pass"><samp style="color:black">*</samp></p>
    <p><input type="submit" value="Авторизироваться" name="go"></p>
</form>

<?php


$server = '172.16.1.6'; // Имя или адрес сервера
$user = 'tli'; // Имя пользователя БД
$password = 'tli'; // Пароль пользователя
$db = 'tli'; // Название БД

$con = mysqli_connect($server, $user, $password, $db);

if (isset($_POST['pass']) && isset($_POST['login'])) {


    $login  = htmlspecialchars($_POST['login']);
    $pass = $_POST['pass'];

    //разбиение на ФИО
    $arr = explode(" ", $login);

    $name = $arr[0];
    $surname = $arr[1];
    $middleName = $arr[2];

    $checkPass = mysqli_query($con, "SELECT `access_code` FROM `employees` 
            WHERE `name` = '$name' AND `surname` = '$surname' AND `middle_name` = '$middleName' AND `access_code` = '$pass' ");
    $row = $checkPass->fetch_assoc();

    if (isset($row['access_code'])) {
        session_start();
        $_SESSION['loginUp'] = 1;
        echo "<span>1</span>";
    } else {
        echo "<span>0</span>";
    }
} else {
    echo "<span>0</span>";
}
