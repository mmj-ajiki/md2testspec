#
# [FILE] detect_test_items.pl
#
# [DESCRIPTION]
#  Markdownファイルの中からテストするチェック項目を抽出する
#
# [HOW TO RUN]
#   > perl detect_test_items.pl <MDファイル名> <言語 jp or en>
#
# [NOTE]
#  書き出し開始：見出し（#が先頭文字）、かつ{.testitems}が付与されているとき
#  書き出し終了：見出しのみ
#
use utf8;
use open ":utf8";
use open qw( :std :encoding(UTF-8) );

# 引数の個数チェック
if (@ARGV < 1) {
  die "Specify the 1st argument as the input MD file"
}
if (@ARGV < 2) {
  die "Specify en or jp as the 2nd argument"
}

my $input_md_file = $ARGV[0];
my $language = $ARGV[1];
my $num = 1;  # 項目番号
my $write_flg = 0; # 書き込むかどうか
my $table_flg = 0; # 表かどうか

open(MDFILE, "< $input_md_file") or die("error :$!");

while (<MDFILE>) {
  my($line) = $_ ;
  if ($line =~ /^#/ && $line =~ /{.testitems}/) { # 書き出し開始
    $write_flg = 1;
    $table_flg = 0;
  } elsif ($line =~ /^#/) { # 書き出し終了
    $write_flg = 0;
    $table_flg = 0;
  } 
  
  if ($write_flg > 0) {
    if ($line =~ /^\|/ ) { # 表を特定
      $line =~ s/\r//g; # 改行を削除
      $line =~ s/\n//g;
      if ($table_flg < 1) { # 表の1行目
        if ($language eq "jp") {
          $line = "| # " . $line . " テスト結果 | メモ |"
        } elsif ($language eq "en") {
          $line = "| # " . $line . " Test Results | Remark |"
        }
      } else {
        if ($line =~ /^\|:--/ || $line =~ /^\|: --/) { # 表の2行目（左寄せ）
          $line = "|:--" . $line . ":--|:--|";
        } elsif ($line =~ /^\| ---/ || $line =~ /^\|---/) { # 表の2行目（センタリング）
          $line = "| --- " . $line . " --- | --- |";
        } else {  # 表の3行目から
          $line = "| $num " . $line . " OK, NG or Attn | - |";
          $num = $num + 1;
        }
      }
      $line = $line . "\n";
      $table_flg = 1;
    #} elsif ($line =~ /^\[/ && ($line =~ /image/ || $line =~ /Image/ || $line =~ /img/ || $line =~ /Img/)) { # 図を書き出す
      #$line = $line . "\n";
      #print($line);
    } else {
      $table_flg = 0; # 表が終わったと仮定する
    }
    print($line);
  }
}

#
# HISTORY
# [1] 2025-01-23 - First release
#