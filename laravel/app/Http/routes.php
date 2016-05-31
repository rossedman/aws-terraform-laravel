<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

use App\User;
use Illuminate\Contracts\Cache\Repository as Cache;

Route::get('/', function () {
    return view('welcome');
});

Route::get('test', function () {
    return view('test');
});

Route::get('cache/get', function (Cache $cache) {
    return $cache->get('test_key');
});

Route::get('cache/set', function (Cache $cache) {
    $cache->put('test_key', 'value', 10);
    return 'Saved to Cache';
});

Route::get('user/create', function (User $user) {
    $user->create([
        'name' => 'Ross Edman',
        'email' => 'ross.edman@slalom.com',
        'password' => 'password'
    ]);
});

Route::get('user/get', function (User $user) {
    return $user->all();
});
