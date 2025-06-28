<?php

$server = 'localhost'; // Имя или адрес сервера
$user = 'root'; // Имя пользователя БД
$password = ''; // Пароль пользователя
$db = 'tli'; // Название БД

$con = mysqli_connect($server, $user, $password, $db);

$checkPass = mysqli_query($con, "SELECT `access_code` FROM `employees`");

$timeArr = array();

$json = file_get_contents('online.json');
  

$prevJson = json_decode($json,true);

$onlineList = array('online' => false);

print_r($prevJson);

echo "<br>";

while ($row = $checkPass->fetch_assoc()) {
    //echo $row['access_code'] . "<br>";
    $filename = './upload/AppsView' . $row['access_code'] . '.json';
    if (file_exists($filename)) {
        echo "Файл $filename в последний раз был изменён: " . date("F d Y H:i:s.", filectime($filename));
    }
    

    $timeArr[$row['access_code']] = date("F d Y H:i:s.", filectime($filename));

    $dataLast = date("F d Y H:i:s.", filectime($filename));

    $res =  intval(time())  - intval(strtotime($prevJson[$row['access_code']]));
    echo "Результат" . $res;

    /*if(strtotime($prevJson[$row['access_code']]) == strtotime($timeArr[$row['access_code']]))
    {
        $onlineList['online'] = false;
        echo "данные не передаются";
        
    }*/
    if($res >= 0 && $res <= 10) {
        $onlineList['online'] = true;
        echo "передача данных";
    }

    else {
        $onlineList['online'] = false;
        echo "данные не передаются";
    }
    echo "<br>";

    $json_data = json_encode($onlineList);
    file_put_contents('./upload/online' . $row['access_code'] . '.json', $json_data);
    
}

$json_data = json_encode($timeArr);
file_put_contents('online.json', $json_data);


header("refresh: 10;");
