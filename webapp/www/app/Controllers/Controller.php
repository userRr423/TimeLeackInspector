<?php

class Controller extends Model
{
    //связывание маршрута с определенным классом в папке Controllers
    public static function CreateView($viewName) {
        
        require_once("./Views/$viewName.php");
    }
}