<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Upload
{
    private static function safeName(string $name): string
    {
        $name = basename(str_replace('\\','/',$name));
        $name = preg_replace('/[^A-Za-z0-9._-]+/', '_', $name) ?: 'upload';
        return ltrim($name, '.');
    }

    /**
     * Save an HTTP upload while preserving the destination directory ACL.
     *
     * On Windows, move_uploaded_file() can retain the ACL inherited by the
     * PHP temporary upload file. When that file is moved into gamefiles,
     * IIS_IUSRS/Users read permissions may be missing and IIS can route the
     * request through index.php instead of serving the existing SWF.
     *
     * copy() creates a new file in the destination directory, so Windows gives
     * it the destination directory's inherited ACL. The source is still
     * verified with is_uploaded_file() before copying.
     */
    private static function saveUploadedFile(string $tmp, string $target): bool
    {
        if ($tmp === '' || !is_uploaded_file($tmp)) {
            return false;
        }

        if (PHP_OS_FAMILY === 'Windows') {
            if (!copy($tmp, $target)) {
                return false;
            }

            @unlink($tmp);
            clearstatcache(true, $target);
            return is_file($target);
        }

        return move_uploaded_file($tmp, $target);
    }
    public static function image(array $file, string $dir): string
    {
        if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) throw new \RuntimeException('Image upload failed.');
        if (($file['size'] ?? 0) > 8*1024*1024) throw new \RuntimeException('Image must be 8 MB or smaller.');
        $name=self::safeName((string)$file['name']); $ext=strtolower(pathinfo($name,PATHINFO_EXTENSION));
        if (!in_array($ext,['png','jpg','jpeg','gif','webp','svg'],true)) throw new \RuntimeException('Unsupported image format.');
        if (!is_dir($dir) && !mkdir($dir,0775,true) && !is_dir($dir)) throw new \RuntimeException('Upload directory is not writable.');
        $target=$dir.'/'.$name; if (is_file($target)) $target=$dir.'/'.pathinfo($name,PATHINFO_FILENAME).'-'.date('YmdHis').'.'.$ext;
        if (!self::saveUploadedFile((string)$file['tmp_name'],$target)) throw new \RuntimeException('Could not save image.');
        return basename($target);
    }
    public static function swfCreateOnly(array $file, string $dir): string
    {
        $error = (int)($file['error'] ?? UPLOAD_ERR_NO_FILE);
        if ($error !== UPLOAD_ERR_OK) {
            $message = match ($error) {
                UPLOAD_ERR_INI_SIZE => 'SWF is larger than the PHP upload_max_filesize limit.',
                UPLOAD_ERR_FORM_SIZE => 'SWF is larger than the form upload limit.',
                UPLOAD_ERR_PARTIAL => 'SWF upload was interrupted before the file finished uploading.',
                UPLOAD_ERR_NO_FILE => 'No SWF file was received. If you selected one, check PHP post_max_size/upload_max_filesize.',
                UPLOAD_ERR_NO_TMP_DIR => 'PHP temporary upload directory is missing.',
                UPLOAD_ERR_CANT_WRITE => 'PHP could not write the uploaded SWF to its temporary directory.',
                UPLOAD_ERR_EXTENSION => 'A PHP extension stopped the SWF upload.',
                default => 'SWF upload failed with PHP upload error '.$error.'.',
            };
            throw new \RuntimeException($message);
        }
        if (($file['size'] ?? 0) > 64*1024*1024) throw new \RuntimeException('SWF must be 64 MB or smaller.');
        $name=self::safeName((string)$file['name']); if (strtolower(pathinfo($name,PATHINFO_EXTENSION))!=='swf') throw new \RuntimeException('Only .swf files are accepted.');
        if (!is_dir($dir) && !mkdir($dir,0775,true) && !is_dir($dir)) throw new \RuntimeException('Destination is not writable.');
        $target=$dir.'/'.$name; if (file_exists($target)) throw new \RuntimeException('That SWF already exists. Existing gamefile SWFs are protected from overwrite.');
        if (!self::saveUploadedFile((string)$file['tmp_name'],$target)) throw new \RuntimeException('Could not save SWF.');
        return $name;
    }
}
