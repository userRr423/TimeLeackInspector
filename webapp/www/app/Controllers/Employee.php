<?php



class Employee extends Controller
{
    public static $Monitoringfile = "123";
    public static function showInfo($divClass, $name, $surname, $middleName)
    {
    
        $arr = self::fetch_assoc("SELECT * FROM `employees` WHERE `name` = '$name' 
        AND `surname` = '$surname' AND `middle_name` = '$middleName'"); ?>

        <div class="<?php echo $divClass ?>">
            <?php echo $arr['name'] . " " . $arr['surname'] . " " . $arr['middle_name']?>
        </div>

        <div class="<?php echo $divClass ?>">
            <?php echo "Дата устройства: " . $arr['employed_at'] ?>
        </div>

        <?php
    }
    public static function GetCodeStr($middleName, $surname, $name)
    {
        $arr = self::fetch_assoc("SELECT `access_code` FROM `employees` WHERE 
        `name` = '$name' AND `surname` = '$surname' AND `middle_name` = '$middleName'");
        self::$Monitoringfile = strval($arr['access_code']);
    }
}
