<?php
// Inspect SWF timeline labels and exported ActionScript linkage names without executing it.
function swfInfo(string $file): array {
 $raw=file_get_contents($file);$sig=substr($raw,0,3);
 $s=$sig==='CWS'?gzuncompress(substr($raw,8)):($sig==='FWS'?substr($raw,8):throw new RuntimeException('Unsupported SWF '.$file));
 $p=(int)ceil((5+4*(ord($s[0])>>3))/8)+4;$labels=[];$symbols=[];
 while($p+2<=strlen($s)){$h=unpack('v',substr($s,$p,2))[1];$p+=2;$tag=$h>>6;$len=$h&63;if($len===63){$len=unpack('V',substr($s,$p,4))[1];$p+=4;}$d=substr($s,$p,$len);$p+=$len;
 if($tag===43)$labels[]=strtok($d,"\0");
 if($tag===76||$tag===56){$n=unpack('v',substr($d,0,2))[1];$o=2;for($i=0;$i<$n;$i++){$id=unpack('v',substr($d,$o,2))[1];$o+=2;$end=strpos($d,"\0",$o);$symbols[$id]=substr($d,$o,$end-$o);$o=$end+1;}}
 if($tag===0)break;}
 return ['labels'=>$labels,'symbols'=>array_values($symbols)];
}
if(realpath($_SERVER['SCRIPT_FILENAME'])===__FILE__)foreach(array_slice($argv,1) as $f)echo $f.' '.json_encode(swfInfo($f)).PHP_EOL;
