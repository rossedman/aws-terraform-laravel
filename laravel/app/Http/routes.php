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

Route::auth();
Route::get('/', function () {
    return view('welcome');
});
Route::get('/home', 'HomeController@index');

Route::get('test', function () {
    return view('test');
});

Route::get('cache/get', function (Cache $cache) {
    return $cache->get('test_key');
});

Route::get('cache/set', function (Cache $cache) {
    return $cache->put('test_key', 'value', 10);
});

Route::get('user/create', function (User $user) {
    return $user->create([
        'name' => 'Ross Edman',
        'email' => 'ross.edman@slalom.com',
        'password' => 'password'
    ]);
});

Route::get('user/get', function (User $user) {
    return $user->all();
});

Route::get('session/store', function() {
    return session(['test' => 'session']);
});

Route::get('session/get', function() {
    return session('test');
});

Route::get('filesystem/test', function() {
    return Storage::disk('s3')->files('/');
});

Route::get('jobs/test', function (User $user) {
    return dispatch(new App\Jobs\TestQueue($user));
});

Route::get('email/test', function () {
    return Mail::send('emails.reminder', [], function ($m) {
        $m->from('admin@rossedman.me', 'Your Application');
        $m->to('ross.edman@slalom.com', 'Ross Edman')->subject('Your Reminder!');
    });
});
