#!C:\indigoperl\perl\bin\perl.exe -w

use CGI;


# ***** pulizia del file di log

open LOG, "./log.txt" or die "Non posso aprire il file dei log!";
open TEMP, ">./temp.txt" or die "Non posso aprire il file dei log!";


while ( <LOG> ) { if ( /^bc/ ) { print TEMP "\n$_" }
		  else { chomp $_; $_ =~ s/\;.*//; print TEMP "$_"; }
}

close LOG;
close TEMP;

# ***** fine pulizia file di log

open LOG, "./temp.txt" or die "Non posso aprire il file dei log!";

open IPCENTRALI, ">ipcentrali.txt" or die "Non posso creare il file delle centrali";

open HTML, ">log.html" or die "Non posso creare il file di output HTML";



my $q = new CGI;

select HTML;
print	$q -> start_html("VERIFICA MMI by BOA"),
	$q -> p ("LO STANDARD E' IL SEGUENTE:"),
	$q -> p ("SERVER .144 ---> MMI .159"),
	$q -> p ("SERVER .32 ---> MMI .51");



# crea tabella e header
print "<TABLE width=\"100%\" border=1 align = \"center\">";
print "<TH>num</TH><TH>SERVER</TH><TH>IP SERVER</TH><TH>IP CENTRALE</TH><TH>VERIFICA</TH>";


my ( $server, $ip, $mmi, $verifica, $riga);
$riga=1;


while ( <LOG> ) { if ( /^bc/ ) { chomp ($server=$_);
		} elsif ( /^Reply/ ) { 
    
		    $i = index($_,"10.");
		    $fi = index($_,":") -$i;    
    		    $ip = $ipserver = substr ($_,$i,$fi);
    		    #print "l'ip del server $server inizia al carattere numero $i e' lungo $fi caratteri e vale $ip\n";
		    
		    $j = rindex($_,"=10.") +1;
    		    $mmi = $ipmmi = substr($_,$j);
    		    chomp $mmi;
    		    chomp $ipmmi;

    		    #print "l'ip della centrale allarmi MMI vale $mmi\n";
    		    print IPCENTRALI "$server $ipmmi\n";
    		    
		    # estrae ultimo otteto ip server
    		    $i = rindex ($ip,".") +1;
    		    $ip = substr($ip,$i);

		    # estrae ultimo otteto ip mmi
		    $j = rindex ($mmi,".") +1; 
		    $mmi = substr($mmi, $j);
    		    
    		    #print "questo e' l'ultimo otteto del server $ip e questo di mmi $mmi\n"; 		    
    		    
    		    print "<TR><TD align = \"center\">$riga</TD><TD align = \"center\">$server</TD><TD align = \"center\">$ipserver</TD><TD align = \"center\">$ipmmi</TD>";
    		    $riga++;
    		    if ((( $ip == 144)&&($mmi == 159))||( $ip == 32)&&($mmi == 51)) { print "<TD align = \"center\" bgcolor=\"green\">OK<TD></TR>\n"; }
    		    else { print "<TD align = \"center\" bgcolor=\"red\">KO</TD></TR>\n";}
		}
}


print "</TABLE>";
print	$q -> end_html;



