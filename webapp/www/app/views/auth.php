<!DOCTYPE html>

<head>
    <title>Регистрация</title>
    <meta charset="utf-8">


    <style>
        <?php include "./static/css/style.css"; ?>
    </style>
</head>

<body>
    <img class="logo-img" src="./static/image/logo.png" alt="">
    <form class="form-registration"  method="post">
        <div class="registartion-item">
            <p class="text-registration">ФИО</p> <input class="registration-input" type="text" name="login">
        </div>
        <div class="registartion-item">
            <p class="text-registration">Должность</p> <input class="registration-input" type="text" name="position">
        </div>
        <div class="registartion-item">
            <p class="text-registration">Код доступа</p> <input class="registration-input" type="password" name="code">
        </div>
        <input class="registration-btn"  type="submit" name="doGoR">
    </form>

    <?php Auth::checkUser();  ?>

</body>