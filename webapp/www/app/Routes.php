<?php

Route::set('index.php', function() {
    Index::CreateView('Index');
});


Route::set('auth', function() {
    Auth::CreateView('Auth');
});

Route::set('menu', function() {
    Controller::CreateView('Menu');
});

Route::set('employee', function() {
    Controller::CreateView('Employee');
});


//проверка на корректность маршрута
$notFound = true;
$arr = Route::getRoutes();
foreach($arr as $route)
{
    if(Route::getUrl() === $route)
    {
        $notFound = false;
    }
}

if ($notFound)
{
    require './views/NotFound.php';
}

?>