<!DOCTYPE html>
<html>

<head>
    <title>загрузка</title>
    <meta charset="utf-8" />
</head>

<body>
    <?php
    session_start();
    if ($_FILES && $_FILES["filename"]["error"] == UPLOAD_ERR_OK) {
        $name = "upload/" . $_FILES["filename"]["name"];
        move_uploaded_file($_FILES["filename"]["tmp_name"], $name);
        echo "Файл загружен";
    }
    ?>
    <h2>Загрузка файла</h2>
    <form method="post" enctype="multipart/form-data">
        Выберите файл: <input type="file" name="filename" size="10" /><br /><br />
        <input type="submit" value="Загрузить" />
    </form>
</body>