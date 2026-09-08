<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class HttpException extends \RuntimeException
{
    public function __construct(private int $httpStatus, string $message = '')
    {
        parent::__construct($message !== '' ? $message : 'HTTP ' . $httpStatus);
    }
    public function status(): int { return $this->httpStatus; }
}
