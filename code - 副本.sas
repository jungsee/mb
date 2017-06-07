
/******** 01.  lev �ʲ���ծ��  *********/

DATA d1 (Label="��ծ����" where=(substr(Accper,6,5)="12-31" and Typrep="A"  )  );
Infile 'D:\mb\��ծ����\ngwvq2m3\FI_T1.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format Indcd $20.;
Format F010401A 20.8;
Format F010801B 20.8;
Format F011201A 20.8;
Format F011901A 20.8;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat Indcd $20.;
Informat F010401A 20.8;
Informat F010801B 20.8;
Informat F011201A 20.8;
Informat F011901A 20.8;
Label Stkcd="��Ʊ����";
Label Accper="��ֹ����";
Label Typrep="�������ͱ���";
Label Indcd="��ҵ����";
Label F010401A="�ֽ����";
Label F010801B="��Ӫ��������ֽ��������������ծ";
Label F011201A="�ʲ���ծ��";
Label F011901A="�����ʱ���ծ��";
Input Stkcd $ Accper $ Typrep $ Indcd $ F010401A F010801B F011201A F011901A ;
Run;



/******** 02.  ��������   *********/

DATA d2 (Label="�����ۺ���Ϣ�ļ�");
Infile 'D:\mb\��������\0vnauzyt\CG_Ybasic.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format Annodt $10.;
Format Y1101a 10.;
Format Y1101b 10.;
Format Excuhldn 15.;
Format Mngmhldn 15.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat Annodt $10.;
Informat Y1101a 10.;
Informat Y1101b 10.;
Informat Excuhldn 15.;
Informat Mngmhldn 15.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label Annodt="��������";
Label Y1101a="��������";
Label Y1101b="���У�������������";
Label Excuhldn="�߹ֹܳ�����";
Label Mngmhldn="�����ֹ�����";
Input Stkcd $ Reptdt $ Annodt $ Y1101a Y1101b Excuhldn Mngmhldn ;
Run;




/******** 03.  �ɱ��ṹ   *********/

DATA d3 (Label="�ɱ��ṹ�ļ�");
Infile 'D:\mb\�ɶ��ɱ�\s4n3jrpi\CG_Capchg.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format Nshrttl 15.;
Format Nshrstt 15.;
Format Nshrlpd 15.;
Format Nshrlpf 15.;
Format Nshrlpn 15.;
Format Nshremp 15.;
Format Nshra 15.;
Format Nshroft 15.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat Nshrttl 15.;
Informat Nshrstt 15.;
Informat Nshrlpd 15.;
Informat Nshrlpf 15.;
Informat Nshrlpn 15.;
Informat Nshremp 15.;
Informat Nshra 15.;
Informat Nshroft 15.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label Nshrttl="�ܹ���";
Label Nshrstt="���У����йɹ���";
Label Nshrlpd="���У����ڷ����˷��˹ɹ���";
Label Nshrlpf="���У����ⷢ���˷��˹ɹ���";
Label Nshrlpn="���У�ļ�����˹ɹ���";
Label Nshremp="���У��ڲ�ְ���ɹ���";
Label Nshra="���У�A����ͨ����";
Label Nshroft="���У�����������ͨ��";
Input Stkcd $ Reptdt $ Nshrttl Nshrstt Nshrlpd Nshrlpf Nshrlpn Nshremp Nshra Nshroft ;
Run;




/******** 04.  �ʱ��ṹ   *********/

DATA d4 (Label="���й�˾�ɱ��ṹ�ļ�");
Infile 'D:\mb\�ɱ��ṹ03\deuaupdi\HLD_Capstru.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format Nshrttl 20.;
Format Nshrstt 20.;
Format Nshrlpd 20.;
Format Nshrlpf 20.;
Format Nshremp 20.;
Format Nshrsms 20.;
Format Nshra 20.;
Format Nshroft 20.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat Nshrttl 20.;
Informat Nshrstt 20.;
Informat Nshrlpd 20.;
Informat Nshrlpf 20.;
Informat Nshremp 20.;
Informat Nshrsms 20.;
Informat Nshra 20.;
Informat Nshroft 20.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label Nshrttl="�ɱ�����";
Label Nshrstt="���У����й�";
Label Nshrlpd="���У����ڷ����˹�";
Label Nshrlpf="���У����ⷢ���˹�";
Label Nshremp="���У��ڲ�ְ����";
Label Nshrsms="���У��߼�������Ա�ֹ���";
Label Nshra="���У�A����ͨ��";
Label Nshroft="���У�����������ͨ��";
Input Stkcd $ Reptdt $ Nshrttl Nshrstt Nshrlpd Nshrlpf Nshremp Nshrsms Nshra Nshroft ;
Run;



/******** 05.  ���ʲ���ת��   *********/


DATA d5 (Label="��Ӫ����"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ) );
Infile 'D:\mb\��Ӫ����\3znyavb4\FI_T4.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format Indcd $6.;
Format F040501B 20.6;
Format F041201B 20.6;
Format F041401B 20.6;
Format F041701B 20.6;
Format F041702B 20.6;
Format F041703B 20.6;
Format F041704B 20.6;
Format F041705C 20.6;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat Indcd $6.;
Informat F040501B 20.6;
Informat F041201B 20.6;
Informat F041401B 20.6;
Informat F041701B 20.6;
Informat F041702B 20.6;
Informat F041703B 20.6;
Informat F041704B 20.6;
Informat F041705C 20.6;
Label Stkcd="��Ʊ����";
Label Accper="��ֹ����";
Label Typrep="�������ͱ���";
Label Indcd="��ҵ����";
Label F040501B="�����ת��A";
Label F041201B="�����ʲ���ת��A";
Label F041401B="�̶��ʲ���ת��A";
Label F041701B="���ʲ���ת��A";
Label F041702B="���ʲ���ת��B";
Label F041703B="���ʲ���ת��C";
Label F041704B="���ʲ���ת��D";
Label F041705C="���ʲ���ת��TTM";
Input Stkcd $ Accper $ Typrep $ Indcd $ F040501B F041201B F041401B F041701B F041702B F041703B F041704B F041705C ;
Run;



/******** 06.  ���ʲ���ת��   *********/

DATA d6_1 (Label="�����"   where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�����\32crymiz\FS_Comins.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format B001100000 20.4;
Format B001101000 20.4;
Format B001300000 20.4;
Format B001000000 20.4;
Format B002000000 20.4;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat B001100000 20.4;
Informat B001101000 20.4;
Informat B001300000 20.4;
Informat B001000000 20.4;
Informat B002000000 20.4;
Label Stkcd="֤ȯ����";
Label Accper="����ڼ�";
Label Typrep="��������";
Label B001100000="Ӫҵ������";
Label B001101000="Ӫҵ����";
Label B001300000="Ӫҵ����";
Label B001000000="�����ܶ�";
Label B002000000="������";
Input Stkcd $ Accper $ Typrep $ B001100000 B001101000 B001300000 B001000000 B002000000 ;
Run;


DATA d6_2 (Label="�����"   where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�����\pqltqh3b\FS_Comins.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format B001100000 20.4;
Format B001101000 20.4;
Format B001300000 20.4;
Format B001000000 20.4;
Format B002000000 20.4;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat B001100000 20.4;
Informat B001101000 20.4;
Informat B001300000 20.4;
Informat B001000000 20.4;
Informat B002000000 20.4;
Label Stkcd="֤ȯ����";
Label Accper="����ڼ�";
Label Typrep="��������";
Label B001100000="Ӫҵ������";
Label B001101000="Ӫҵ����";
Label B001300000="Ӫҵ����";
Label B001000000="�����ܶ�";
Label B002000000="������";
Input Stkcd $ Accper $ Typrep $ B001100000 B001101000 B001300000 B001000000 B002000000 ;
Run;

data d6;
set d6_1 d6_2;
run;





/******** 07.  ��ְ��һ   *********/

PROC IMPORT OUT=d7
            DATAFILE= "D:\mb\��ְ��һ\dual.xls"
            DBMS=EXCEL REPLACE;
     SHEET="Sheet0$";
     GETNAMES=YES;
RUN;

data d7(drop=firm);
length 	Stkcd $6.;
set d7;
Stkcd=substr(firm,1,6);
run;


data d7_2015;
set d7;
if year=2015;
run;

data d7_2016;
set d7_2015;
year=year+1;
run;


data  d7_new;
set d7 d7_2016;
proc sort;
by Stkcd year;
run;

data d7;
set   d7_new;
run;



/******** 08.  ʮ��ɶ�   *********/

DATA d8_1 (Label="ʮ��ɶ��ļ�"  where=(substr(Reptdt,6,5)="12-31" and S0501b=1  ));
Infile 'D:\mb\ʮ��ɶ�\k4yocivc\CG_Sharehold.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format S0101b $200.;
Format S0201b 20.;
Format S0301b 14.4;
Format S0401b $50.;
Format S0501b 6.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat S0101b $200.;
Informat S0201b 20.;
Informat S0301b 14.4;
Informat S0401b $50.;
Informat S0501b 6.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label S0101b="�ɶ�����";
Label S0201b="�ֹ�����";
Label S0301b="�ֹɱ���(%)";
Label S0401b="�ɷ�����";
Label S0501b="�ֹ�����";
Input Stkcd $ Reptdt $ S0101b $ S0201b S0301b S0401b $ S0501b ;
Run;


DATA d8_2 (Label="ʮ��ɶ��ļ�"  where=(substr(Reptdt,6,5)="12-31" and S0501b=1  ));
Infile 'D:\mb\ʮ��ɶ�\vigeu0yu\CG_Sharehold.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format S0101b $200.;
Format S0201b 20.;
Format S0301b 14.4;
Format S0401b $50.;
Format S0501b 6.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat S0101b $200.;
Informat S0201b 20.;
Informat S0301b 14.4;
Informat S0401b $50.;
Informat S0501b 6.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label S0101b="�ɶ�����";
Label S0201b="�ֹ�����";
Label S0301b="�ֹɱ���(%)";
Label S0401b="�ɷ�����";
Label S0501b="�ֹ�����";
Input Stkcd $ Reptdt $ S0101b $ S0201b S0301b S0401b $ S0501b ;
Run;


DATA d8_3 (Label="ʮ��ɶ��ļ�"  where=(substr(Reptdt,6,5)="12-31" and S0501b=1  ));
Infile 'D:\mb\ʮ��ɶ�\xidqs3hq\CG_Sharehold.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Reptdt $10.;
Format S0101b $200.;
Format S0201b 20.;
Format S0301b 14.4;
Format S0401b $50.;
Format S0501b 6.;
Informat Stkcd $6.;
Informat Reptdt $10.;
Informat S0101b $200.;
Informat S0201b 20.;
Informat S0301b 14.4;
Informat S0401b $50.;
Informat S0501b 6.;
Label Stkcd="֤ȯ����";
Label Reptdt="ͳ�ƽ�ֹ����";
Label S0101b="�ɶ�����";
Label S0201b="�ֹ�����";
Label S0301b="�ֹɱ���(%)";
Label S0401b="�ɷ�����";
Label S0501b="�ֹ�����";
Input Stkcd $ Reptdt $ S0101b $ S0201b S0301b S0401b $ S0501b ;
Run;

data d8;
set d8_1 d8_2 d8_3;
run;



/******** 09.  ������ֵ��   *********/

DATA d9 (Label="��Լ�ֵָ��"  where=(substr(Accper,6,5)="12-31"   ));
Infile 'D:\mb\��ֵ��\ut1qjees\FI_T10.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Indcd $6.;
Format F100401A 20.4;
Format F100801A 20.2;
Format F100802A 20.2;
Format F100901A 20.4;
Format F100902A 20.4;
Format F100903A 20.4;
Format F100904A 20.4;
Format F101001A 20.4;
Format F101002A 20.4;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Indcd $6.;
Informat F100401A 20.4;
Informat F100801A 20.2;
Informat F100802A 20.2;
Informat F100901A 20.4;
Informat F100902A 20.4;
Informat F100903A 20.4;
Informat F100904A 20.4;
Informat F101001A 20.4;
Informat F101002A 20.4;
Label Stkcd="��Ʊ����";
Label Accper="��ֹ����";
Label Indcd="��ҵ����";
Label F100401A="�о���";
Label F100801A="��ֵA";
Label F100802A="��ֵB";
Label F100901A="�б�QֵA";
Label F100902A="�б�QֵB";
Label F100903A="�б�QֵC";
Label F100904A="�б�QֵD";
Label F101001A="������ֵ��A";
Label F101002A="������ֵ��B";
Input Stkcd $ Accper $ Indcd $ F100401A F100801A F100802A F100901A F100902A F100903A F100904A F101001A F101002A ;
Run;



/******** 10. �ֽ���   *********/

DATA d10 (Label="�ֽ�������"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�ֽ���\d3kc3d2m\FI_T6.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format Indcd $6.;
Format F061201B 20.2;
Format F061201C 20.2;
Format F061301B 20.2;
Format F062401B 20.2;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat Indcd $6.;
Informat F061201B 20.2;
Informat F061201C 20.2;
Informat F061301B 20.2;
Informat F062401B 20.2;
Label Stkcd="��Ʊ����";
Label Accper="��ֹ����";
Label Typrep="�������ͱ���";
Label Indcd="��ҵ����";
Label F061201B="�۾�̯��";
Label F061201C="�۾�̯��TTM";
Label F061301B="��˾�ֽ���1";
Label F062401B="��ҵ�����ֽ���";
Input Stkcd $ Accper $ Typrep $ Indcd $ F061201B F061201C F061301B F062401B ;
Run;




/******** 11. �ֽ�������ֱ�ӷ���   *********/

DATA d11 (Label="�ֽ�������ֱ�ӷ���"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�ֽ�������\wnzyyv0s\FS_Comscfd.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format C001000000 20.2;
Format C002000000 20.2;
Format C003000000 20.2;
Format C005000000 20.2;
Format C005001000 20.2;
Format C006000000 20.2;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat C001000000 20.2;
Informat C002000000 20.2;
Informat C003000000 20.2;
Informat C005000000 20.2;
Informat C005001000 20.2;
Informat C006000000 20.2;
Label Stkcd="֤ȯ����";
Label Accper="����ڼ�";
Label Typrep="��������";
Label C001000000="��Ӫ��������ֽ���������";
Label C002000000="Ͷ�ʻ�������ֽ���������";
Label C003000000="���ʻ�������ֽ���������";
Label C005000000="�ֽ��ֽ�ȼ��ﾻ���Ӷ�";
Label C005001000="�ڳ��ֽ��ֽ�ȼ������";
Label C006000000="��ĩ�ֽ��ֽ�ȼ������";
Input Stkcd $ Accper $ Typrep $ C001000000 C002000000 C003000000 C005000000 C005001000 C006000000 ;
Run;




/******** 12. ӯ������   *********/

DATA d12 (Label="ӯ������"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\ӯ������\xw040ht0\FI_T5.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format Indcd $6.;
Format F050101B 20.4;
Format F050201B 20.4;
Format F050202B 20.4;
Format F050203B 20.4;
Format F050204C 20.4;
Format F050601B 20.4;
Format F050601C 20.4;
Format F050701B 20.4;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat Indcd $6.;
Informat F050101B 20.4;
Informat F050201B 20.4;
Informat F050202B 20.4;
Informat F050203B 20.4;
Informat F050204C 20.4;
Informat F050601B 20.4;
Informat F050601C 20.4;
Informat F050701B 20.4;
Label Stkcd="��Ʊ����";
Label Accper="��ֹ����";
Label Typrep="�������ͱ���";
Label Indcd="��ҵ����";
Label F050101B="�ʲ�������A";
Label F050201B="���ʲ��������ʣ�ROA��A";
Label F050202B="���ʲ��������ʣ�ROA��B";
Label F050203B="���ʲ��������ʣ�ROA��C";
Label F050204C="���ʲ��������ʣ�ROA��TTM";
Label F050601B="Ϣ˰ǰ����";
Label F050601C="Ϣ˰ǰ����TTM";
Label F050701B="Ϣǰ˰������";
Input Stkcd $ Accper $ Typrep $ Indcd $ F050101B F050201B F050202B F050203B F050204C F050601B F050601C F050701B ;
Run;




/******** 13. �ʲ���ծ��   *********/

DATA d13_1 (Label="�ʲ���ծ��"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�ʲ���ծ��\2ih3vbvk\FS_Combas.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format A001100000 20.;
Format A001212000 20.;
Format A001218000 20.;
Format A001000000 20.;
Format A002206000 20.;
Format A002000000 20.;
Format A003000000 20.;
Format A004000000 20.;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat A001100000 20.;
Informat A001212000 20.;
Informat A001218000 20.;
Informat A001000000 20.;
Informat A002206000 20.;
Informat A002000000 20.;
Informat A003000000 20.;
Informat A004000000 20.;
Label Stkcd="֤ȯ����";
Label Accper="����ڼ�";
Label Typrep="��������";
Label A001100000="�����ʲ��ϼ�";
Label A001212000="�̶��ʲ�����";
Label A001218000="�����ʲ�����";
Label A001000000="�ʲ��ܼ�";
Label A002206000="���ڸ�ծ�ϼ�";
Label A002000000="��ծ�ϼ�";
Label A003000000="������Ȩ��ϼ�";
Label A004000000="��ծ��������Ȩ���ܼ�";
Input Stkcd $ Accper $ Typrep $ A001100000 A001212000 A001218000 A001000000 A002206000 A002000000 A003000000 A004000000 ;
Run;


DATA d13_2 (Label="�ʲ���ծ��"  where=(substr(Accper,6,5)="12-31" and Typrep="A"  ));
Infile 'D:\mb\�ʲ���ծ��\fhsepvox\FS_Combas.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format A001100000 20.;
Format A001212000 20.;
Format A001218000 20.;
Format A001000000 20.;
Format A002206000 20.;
Format A002000000 20.;
Format A003000000 20.;
Format A004000000 20.;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat A001100000 20.;
Informat A001212000 20.;
Informat A001218000 20.;
Informat A001000000 20.;
Informat A002206000 20.;
Informat A002000000 20.;
Informat A003000000 20.;
Informat A004000000 20.;
Label Stkcd="֤ȯ����";
Label Accper="����ڼ�";
Label Typrep="��������";
Label A001100000="�����ʲ��ϼ�";
Label A001212000="�̶��ʲ�����";
Label A001218000="�����ʲ�����";
Label A001000000="�ʲ��ܼ�";
Label A002206000="���ڸ�ծ�ϼ�";
Label A002000000="��ծ�ϼ�";
Label A003000000="������Ȩ��ϼ�";
Label A004000000="��ծ��������Ȩ���ܼ�";
Input Stkcd $ Accper $ Typrep $ A001100000 A001212000 A001218000 A001000000 A002206000 A002000000 A003000000 A004000000 ;
Run;


data d13;
set d13_1 d13_2;
run;




/******** 14. �з�����   *********/

PROC IMPORT OUT=d14_temp
            DATAFILE= "D:\mb\rd.xls"
            DBMS=EXCEL REPLACE;
     SHEET="Sheet2$";
     GETNAMES=YES;
RUN;


data d14(drop=name2 firm);
length 	Stkcd $6.;
set d14_temp;
drop d1990-d2005;

Stkcd=substr(firm,1,6);
run;


data split;
set d14;
array s{11} d2006-d2016;
Subject + 1;
do Time = 1 to 11;
rd = s{time};
output;
end;
drop s1-s11;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  rd;
var rd;
run;


data d14(drop=time);
set  totsplit(keep=Stkcd time rd) ;
year=time+2005;
run;



/******** 15. ��Ԫ��ҵ��   *********/



PROC IMPORT OUT=d15_temp
            DATAFILE= "D:\mb\income\diver.xls"
            DBMS=EXCEL REPLACE;
     SHEET="Sheet2$";
     GETNAMES=YES;
RUN;


data d15_temp2(drop=name3 firm);
length 	Stkcd $6.;
set d15_temp;
Stkcd=substr(firm,1,6);
run;


/********** 1. һ���������� **********/


data d15_1;
set d15_temp2;
keep Stkcd d1_2000-d1_2016;
run;



data split;
set d15_1;
array s{17} d1_2000-d1_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data d15_1(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=1;
if missing(sales) then do;
sales=0;
end;
run;



/********* 2 *********/



data d15_2;
set d15_temp2;
keep Stkcd d2_2000-d2_2016;
run;



data split;
set d15_2;
array s{17} d2_2000-d2_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data d15_2(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=2;
if missing(sales) then do;
sales=0;
end;
run;





/********* 3 *********/



data d15_3;
set d15_temp2;
keep Stkcd d3_2000-d3_2016;
run;



data split;
set d15_3;
array s{17} d3_2000-d3_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data d15_3(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=3;
if missing(sales) then do;
sales=0;
end;
run;





/********* 4 *********/



data d15_4;
set d15_temp2;
keep Stkcd d4_2000-d4_2016;
run;



data split;
set d15_4;
array s{17} d4_2000-d4_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data d15_4(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=4;
if missing(sales) then do;
sales=0;
end;
run;





/********* 5 *********/



data d15_5;
set d15_temp2;
keep Stkcd d5_2000-d5_2016;
run;



data split;
set d15_5;
array s{17} d1_2000-d1_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data d15_5(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=5;
if missing(sales) then do;
sales=0;
end;
run;


data d15;
set  d15_1-d15_5;
proc sort;
by Stkcd year  sales_rank ;
run;


proc sql ;
    create table test as
    select Stkcd, year,sales,sales_rank,sum(sales) as sales_total_by_year
    from d15
	group by  Stkcd, year;
quit;


data test2;
set test;
ratio_square=(sales/sales_total_by_year)**2;
run;


proc sql ;
    create table test3 as
    select Stkcd, year,sales,sales_rank,sales_total_by_year,ratio_square,sum(ratio_square) as hhi
    from test2
	group by  Stkcd, year;
quit;

data d15(keep=Stkcd year hhi bhi);
set  test3;
bhi=1-hhi;
run;


proc sort data=d15 nodupkey;
by Stkcd year;
run;




proc export data=d15  outfile='D:\mb\stata_data\d15.dta';
run;





dm 'log; clear; output; clear;'; 


libname dd "D:\mb\sas_data";

%macro out(num = );

 %do i = 1 %to  &num ;

data dd.d&i;
set d&i;
run;


%end;

%mend out;



%out(num=15); /*****/



libname dd "D:\mb\sas_data";

proc export data=dd.d1  outfile='D:\mb\stata_data\d1.dta';
run;

proc export data=dd.d2  outfile='D:\mb\stata_data\d2.dta';
run;

proc export data=dd.d3  outfile='D:\mb\stata_data\d3.dta';
run;

proc export data=dd.d4  outfile='D:\mb\stata_data\d4.dta';
run;

proc export data=dd.d5  outfile='D:\mb\stata_data\d5.dta';
run;

proc export data=dd.d6  outfile='D:\mb\stata_data\d6.dta';
run;

proc export data=dd.d7  outfile='D:\mb\stata_data\d7.dta';
run;

proc export data=dd.d8  outfile='D:\mb\stata_data\d8.dta';
run;

proc export data=dd.d9  outfile='D:\mb\stata_data\d9.dta';
run;

proc export data=dd.d10  outfile='D:\mb\stata_data\d10.dta';
run;

proc export data=dd.d11  outfile='D:\mb\stata_data\d11.dta';
run;

proc export data=dd.d12  outfile='D:\mb\stata_data\d12.dta';
run;

proc export data=dd.d13  outfile='D:\mb\stata_data\d13.dta';
run;

proc export data=dd.d14  outfile='D:\mb\stata_data\d14.dta';
run;

proc export data=dd.d15  outfile='D:\mb\stata_data\d15.dta';
run;



proc sort data=dd.d1;
by Stkcd Accper;


proc sort data=dd.d2;
by Stkcd Reptdt;

/**** delete ****/
proc sort data=dd.d3;
by Stkcd Reptdt;


proc sort data=dd.d4;
by Stkcd Reptdt;


proc sort data=dd.d5;
by Stkcd Accper;


proc sort data=dd.d6;
by Stkcd Accper;

/********  year *********/
proc sort data=dd.d7;
by Stkcd year;


proc sort data=dd.d8;
by Stkcd Reptdt;


proc sort data=dd.d9;
by Stkcd Accper;


proc sort data=dd.d10;
by Stkcd Accper;


proc sort data=dd.d11;
by Stkcd Accper;

proc sort data=dd.d12;
by Stkcd Accper;

proc sort data=dd.d13;
by Stkcd Accper;

/********  year *********/
proc sort data=dd.d14;
by Stkcd year;


/********  year *********/
proc sort data=dd.d15;
by Stkcd Accper;
run;


/**** ������ Stkcd + year ****/

data all_1;
merge  dd.d7  dd.d14   dd.d15;
by Stkcd year;

proc sort;
by 	Stkcd year;
run;



/**** ������ Stkcd + Accper ****/


data all_2;
merge  dd.d1  dd.d2(rename=(Reptdt=Accper))  dd.d4(rename=(Reptdt=Accper))  dd.d5  dd.d6 dd.d8(rename=(Reptdt=Accper))  dd.d9  dd.d10  dd.d11  dd.d12 dd.d13  ;
by Stkcd Accper;

proc sort;
by 	Stkcd Accper;
run;


data all_2;
set all_2;
year=input(substr(Accper,1,4),4.);
run;


data all;
merge all_1 all_2;
by Stkcd year;
if year>=2000;
if substr(Stkcd,1,1)="2" or substr(Stkcd,1,1)="8" or substr(Stkcd,1,1)="9"  then delete;

label Stkcd="��˾����";
label year="���";
label name="��˾����";
label rd="�з�����";
label duality="��ְ��һ";
label hhi="�շҴ��ָ��";
label bhi="BHIָ��";

proc sort;
by Stkcd year;
run;




proc contents data=all VARNUM 
  out=Content_nurse2012(keep= varnum name label);
run;
proc sort data=Content_nurse2012;
  by varnum;
run;



options nodate nonumber;
ods listing close;
ods printer pdf file ='D:\mb\Variable_Description.pdf';

proc print data=Content_nurse2012;
   
run;
ods printer close;
ods listing;

 


options nodate nonumber;
ods listing close;
ods printer pdf file ='D:\mb\Variable_Description.pdf';

proc print data=Content_nurse2012;
   
run;
ods printer close;
ods listing;

 



ods tagsets.excelxp file="D:\mb\Variable_Description.xls" options(sheet_name="Name") style=analysis;

proc print data=Content_nurse2012;
run;
 

ods tagsets.excelxp close;






PROC EXPORT DATA=all
            OUTFILE= "D:\mb\all_data.xls"
            DBMS=EXCEL REPLACE;
     SHEET="sheet1";
RUN;



data temp;
set all(keep=Stkcd year hhi);
run;

data a;
set temp;
by Stkcd year;
lag_y=lag(hhi);
if first.Stkcd then lag_y=.;
diff_y=hhi-	lag_y;

diff=dif(hhi);
if first.Stkcd then diff=.;
run;


data all_up;
set all;
if duality=1 then dual=1;
else if  duality=2 or  duality=3  then dual=0;
else  dual=.;
label dual="��ְ��һ";
run;




proc reg data=all_up;
model F101001A=rd F041701B S0301b F050601B bhi dual;
run;
quit;



libname dd "D:\mb\sas_data";
data dd.all;
set all;
run;

 


 


PROC IMPORT OUT=d15_temp
            DATAFILE= "D:\mb\income\overseas_sales.xls"
            DBMS=EXCEL REPLACE;
     SHEET="Sheet1$";
     GETNAMES=YES;
RUN;


data d15_temp2(drop=firm);
length 	Stkcd $6.;
set d15_temp;
Stkcd=substr(firm,1,6);
run;


/********** 1. һ���������� **********/


data d15_1;
set d15_temp2;
keep Stkcd d1_2000-d1_2016;
run;



data split;
set d15_1;
array s{17} d1_2000-d1_2016;
Subject + 1;
do Time = 1 to 17;
sales = s{time};
output;
end;
drop s1-s17;
run;



proc transpose data = split out = totsplit prefix = Str;
by   subject;
copy  Stkcd  time  sales;
var sales;
run;


data overseas_sales(drop=time);
set  totsplit(keep=Stkcd time sales) ;
year=time+1999;
sales_rank=1;
if missing(sales) then do;
sales=0;
end;
run;


data  overseas_sales(keep=Stkcd year overseas_sales );
set overseas_sales;
rename sales=overseas_sales;

proc sort;
by Stkcd year;
run;


data dd.all0528;
merge dd.all(in=a)  overseas_sales;
by Stkcd year;
if a;
run;




PROC EXPORT DATA=dd.all0528
            OUTFILE= "D:\mb\all0601.xls"
            DBMS=EXCEL REPLACE;
     SHEET="sheet1";
RUN;







libname dd "D:\mb\sas_data";


data  all0601;
set  dd.all0528;

if duality=1 then dual=1;
else if  duality=2 or  duality=3  then dual=0;
else  dual=.;
label dual="��ְ��һ";
run;

proc sort data=all0601;
by Stkcd year;
run;




data all0601_a;
set all0601;
by Stkcd year;
lag_sales=lag(B001100000);
if first.Stkcd then lag_sales=.;
diff_sales=B001100000-lag_sales;

if lag_sales^=0 then do;
sg=	diff_sales/lag_sales;
end;
else do;
sg=.;
end;
run;



data  all0601_b(rename=(rd_new=rd) drop=cf_new );
set all0601_a;
mb=1/F101001A;

cf_new=C001000000 ;

if cf_new>0 then do;
cf=log(cf_new);
end;
else if   cf_new<0 then do;
cf=-log(abs(cf_new));
end;
else do;
cf_new=.;
end;

if rd>0 then do;
rd_new=log(rd);
end;
else do;
rd_new=.;
end;
drop rd;

own=S0301b*0.01;

if A001000000>0 then do;
size=log(A001000000);
end;
else if A001000000<0 then do;
size=-log(-A001000000);
end;
else do;
size=.;
end;

roa=F050201B;

if F050601B>0 then do;
ebit=log(F050601B);
end;
else if  F050601B<0 then do;
ebit=-log(-F050601B);
end;
else do;
ebit=.;
end;

lev=F011201A;

tat=F041701B;

inddir=Y1101b/Y1101A;

magshare=Excuhldn/Nshrttl;

fin_crisis=(year>=2008);

if year=2000 then do;year2000=1;end;
else do; year2000=0; end;


if year=2001 then do;year2001=1;end;
else do; year2001=0; end;


if year=2002 then do;year2002=1;end;
else do; year2002=0; end;


if year=2003 then do;year2003=1;end;
else do; year2003=0; end;


if year=2004 then do;year2004=1;end;
else do; year2004=0; end;


if year=2005 then do;year2005=1;end;
else do; year2005=0; end;


if year=2006 then do;year2006=1;end;
else do; year2006=0; end;


if year=2007 then do;year2007=1;end;
else do; year2007=0; end;


if year=2008 then do;year2008=1;end;
else do; year2008=0; end;


if year=2009 then do;year2009=1;end;
else do; year2009=0; end;


if year=2010 then do;year2010=1;end;
else do; year2010=0; end;


if year=2011 then do;year2011=1;end;
else do; year2011=0; end;


if year=2012 then do;year2012=1;end;
else do; year2012=0; end;


if year=2013 then do;year2013=1;end;
else do; year2013=0; end;


if year=2014 then do;year2014=1;end;
else do; year2014=0; end;


if year=2015 then do;year2015=1;end;
else do; year2015=0; end;


if year=2016 then do;year2016=1;end;
else do; year2016=0; end;

run;



/****** ������ҵ������� *****/
DATA sic01 (Label="��˾�ļ�"  drop=Nnindnme);
Infile 'D:\mb\��ҵ����\zxfjyiab\TRD_Co.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Nnindcd $10.;
Format Nnindnme $50.;
Informat Stkcd $6.;
Informat Nnindcd $10.;
Informat Nnindnme $50.;
Label Stkcd="֤ȯ����";
Label Nnindcd="��ҵ����C";
Label Nnindnme="��ҵ����C";
Input Stkcd $ Nnindcd $ Nnindnme $ ;
Run;

data sic01;
set sic01;
if substr(Nnindcd,1,1)="J" then delete;
run;


proc export data=sic01 replace outfile='D:\mb\stata_data\sic01.dta';
run;


proc import out=sic02 
        datafile = "D:\mb\stata_data\sic02.dta"
         REPLACE;
        run;




data   all0601_c;
merge all0601_b(in=a)	 sic02(rename=(stkcd=Stkcd));
by Stkcd;
if a;
if substr(Indcd,1,1)="J" then delete;
proc sort;
by Stkcd year;
run;




data   all0601_d;
set  all0601_c;
keep year2000-year2016 sic_dummy1-sic_dummy76  Stkcd year mb cf rd own bhi size roa ebit lev tat sg dual inddir magshare fin_crisis;

label  mb="��ҵ��ֵ����ֵ�������";
label  cf="�ֽ���������Ӫ��������ֽ���������";
label  rd="�з�����";
label  own="��һ��ɶ�����";
label  bhi="BHָ������˾��Ԫ��ָ��";
label  size="��ģ";
label  roa="�ʲ�������";
label  ebit="Ϣ˰ǰ���� ";
label  lev="���ʲ���ծ�� ";
label  tat="���ʲ���ת��";
label  sg="����������";
label  dual="��ְ��һ";
label  inddir="�������±���";
label  magshare="�߹ֹܳɱ���";
label  fin_crisis="�Ƿ���2008�����Σ��֮��";

run;





libname dd "D:\mb\sas_data";

data  dd.all0601_d;
set all0601_d;
run;



dm 'log; clear; output; clear;'; 


proc reg data=dd.all0601_d;
model mb= cf rd own bhi size roa ebit lev tat sg dual inddir magshare fin_crisis year2001-year2016 sic_dummy2-sic_dummy76 ;
run;
quit;



proc contents data=all0601_d VARNUM 
  out=Content_nurse2012(keep= varnum name label);
run;
proc sort data=Content_nurse2012;
  by varnum;
run;



options nodate nonumber;
ods listing close;
ods printer pdf file ='D:\mb\RESULTS\Variable_Description.pdf';

proc print data=Content_nurse2012;
   
run;
ods printer close;
ods listing;

 
options nodate nonumber;
ods listing close;
ods rtf file='D:\mb\RESULTS\Variable_Description.doc';

proc print data=Content_nurse2012;
   
run;

ods rtf close;
ods listing;
