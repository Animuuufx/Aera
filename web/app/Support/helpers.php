<?php
declare(strict_types=1);
use Aera\Foundation\Config;
use Aera\Foundation\Csrf;

function e(mixed $v): string { return htmlspecialchars((string)$v, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }
function url(string $path=''): string { return rtrim((string)Config::get('app.url','https://nightvaults.com'),'/').'/'.ltrim($path,'/'); }
function asset(string $path): string { return '/assets/'.ltrim($path,'/'); }
function csrf_field(): string { return '<input type="hidden" name="_token" value="'.e(Csrf::token()).'">'; }
function checked(mixed $v): string { return $v ? ' checked' : ''; }
