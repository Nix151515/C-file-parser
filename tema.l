/* State Nicolae 333CC */
   
    #include<stdio.h>
    
    int i = 0, j = 0, k = 0, l = 0, m = 0, ok = 0;
    int contor = 0, contor2 = 0, contor3 = 0 , contor4 = 0 ;
    int contor5 = 0;
    int constructors = 0;
    int copy_constructors = 0;
    int destructors = 0;
    int methods = 0;
    int ow_methods = 0;
    
    int classes = -1;
    
    int constrLen = 0;
    int metLen = 0;
    
    int methAux = 0;
    int dup_methods = 0;

    FILE *file;
    
    /*  Arrays to hold all line types   */
    char CLS[100][50];
    char C[100][50] ;
    char CC[100][50] ;
    char D[100][50];
    char M[100][50];
    
    char functions[100][50];
    char dups[100][100];
    
    int type = 1;
    /*
    0 - constructor
    1 - method
    */
    
    int nrConstr[50]; // constructor nr for each class
    int nrMethods[50]; // methods for each class
    int nrDestr[50];
    int nrCpyConstr[50];
        
    
%option noyywrap

name [a-zA-Z]+[0-9]*
datatype bool|char|long|int|double|float|void|[A-Z]+[a-z]+[0-9]*|,|\[|\]|\*
datatypeAux signed|unsigned|short|long|const
number [0-9]+
%%

            
[/]+.*                  {   
                            /*   Comment match   */
                        }


class" "{name}          {
                            /*  Class match  */
                            
                            classes ++;
                            for(contor = 0 ; contor < yyleng ; contor++)
                                CLS[classes][contor] = yytext[contor];
                        }


{datatype}" "+[^(^)^}^{]*\;    { 

                            /*  Declaration match */
                        }


[A-Z].*&.*\;            {

                            /*  Copy - constructor  */
                            
                            for(contor = 0 ; contor < yyleng ; contor++)
                                CC[copy_constructors][contor] = yytext[contor];
                            copy_constructors ++;
                        }

                        
[A-Z]+[a-z]+[0-9]*" "*\(              {

                            /*  Constructor body */
                            
                            type = 0;
                            j = 0;
                            constrLen += yyleng;
                            for(; contor2 < constrLen ; contor2++)
                            {
                                C[constructors][contor2] = yytext[j];
                                j++;
                            }
                        }
                            
                        
                        
~[A-Z].*\;              { 
                            /*  Destructor match  */
                            
                            for(contor = 0 ; contor < yyleng ; contor++)
                                D[destructors][contor] = yytext[contor];
                            destructors ++;
                        }
                        
{datatype}" "*|{datatypeAux}" "*|{number}      {

                            /*  Datatype matching    */
                            
                            if(type == 1)   // Join to method body
                            {
                                i = 0;
                                metLen += yyleng;
                                for(;contor3< metLen; contor3++)
                                {
                                    M[methods][contor3] = yytext[i];
                                    i++;
                                }
                               
                            }
                            
                            if(type == 0)   // Join to constructor body
                            {
                                j = 0;
                                constrLen += yyleng;
                                for(;contor2< constrLen; contor2++)
                                {
                                    C[constructors][contor2] = yytext[j];
                                    j++;
                                }

                            }
                        }
                        
{name}" "?\(            {
                            /*      Method body     */

                            type = 1;
                            i = 0;
                            metLen += yyleng;
                            for(; contor3 < metLen ; contor3++)
                            {
                                /*      Populating functions array    */
                                if(yytext[i] != ' ' && yytext[i] != '(')
                                    functions[methods][i] = yytext[i];
                                    
                                /*      Populating methods array    */
                                M[methods][contor3] = yytext[i];
                                i++;
                            }
                        }



{name}                  {
                            /*      Parameter names, do nothing      */
                        }


\)                      {
                            /*      Constructor or method ending    */
                            
                            if(type == 0)
                            {
                                
                                C[constructors][constrLen] = yytext[0];
                                C[constructors][constrLen+1] = 0;
                                
                                constructors ++;
                                constrLen = 0;
                                contor2 = 0;
                            }
                            if(type == 1)
                            {
                                M[methods][metLen] = yytext[0];
                                M[methods][metLen+1] = 0;
                               
                                methods++;
                                metLen = 0;
                                contor3 = 0;
                            }
                            type = 1;
                        }

\}\;                    {
                            /*          Class ending        */
                            
                            nrConstr[classes] = constructors;
                            nrDestr[classes] = destructors;
                            nrCpyConstr[classes] = copy_constructors;
                            nrMethods[classes] = methods;
                        }
                        
                            

public:|private:|\n|" "|\;|.


%%
int main(int argc, char *argv[]) {

    
    if (file = fopen(argv[1], "r"))
        yyin = file;
    else
        printf("Eroare la deschiderea fisierului \n");
    
    yylex();
    
    /*   Need a different counter for each type to maintain the order
                        between classes             */
                        
    contor = 0;     // constructors
    contor2 = 0 ;   // destructors
    contor3 = 0 ;   // copy-constructors
    contor4 = 0;    // methods
    contor5 = 0;    // overridded

    
    
    for(i = 0; i <= classes; i++)
    {
        /*      Print class     */
        printf("%s\n",CLS[i]);
        
        /*      Print constructors    */
        if(i==0)
            printf("-constructori: %d\n",nrConstr[i]);
        else
            printf("-constructori: %d\n",nrConstr[i]-nrConstr[i-1]);
        for(; contor<nrConstr[i]; contor++)
        {
            printf("\t%s\n",C[contor]);
        }
        
        /*      Print copy-constructors     */
        
        if(i == 0)
            printf("-constructor copiere: %d\n",nrCpyConstr[i]);
        else
            printf("-constructor copiere: %d\n",nrCpyConstr[i]-nrCpyConstr[i-1]);
        for(;contor3 < nrCpyConstr[i] ; contor3++)
        {
            j = 0;
            printf("\t");
            while(CC[contor3][j] != '&')
            {
                printf("%c", CC[contor3][j]);
                j++;
            }
            printf("%c)\n", CC[contor3][j]);
        }
        
        /*      Print destructor     */
        
        if(i == 0)
            printf("-destructor: %d\n",nrDestr[i]);
        else
            printf("-destructor: %d\n",nrDestr[i]-nrDestr[i-1]);
        for(;contor2 < nrDestr[i] ; contor2++)
        {
            printf("\t%s\n",D[contor2]);
        }
        
        /*      Print methods     */
        
        contor5 = contor4;
        j = 0;
        if(i == 0)
            printf("-metode: %d\n",nrMethods[i]);
        else
            printf("-metode: %d\n",nrMethods[i]-nrMethods[i-1]);
        for(; contor4 < nrMethods[i] ; contor4++)
        {
            printf("\t%s\n", M[contor4]);
            methAux ++ ;
            
        }
            

        /*      Finding duplicates and hold them in "dups"    */
        
        for(k = contor5 ; k < contor4 + methAux ; k++)
        {
            for(l = k + 1 ; l < contor5 + methAux; l ++)
            {
                if(strcmp(functions[k],functions[l]) == 0)
                {
                    strcpy(dups[dup_methods],functions[k]);
                    dup_methods++;
                }
            }
        } 

        /*     Erase non-duplicates from methods array  */ 
        for(k = contor5 ; k < contor5 + methAux ; k++)
        {
            for(l = 0 ; l < dup_methods ; l++)
            {
                /*  Found a duplicate  */
                if(strcmp(functions[k],dups[l]) == 0)
                {
                    ok = 1;
                }
            }
            if(ok == 0)
                strcpy(M[k],"Wrong");
            else
                ow_methods ++;
            ok = 0;
        } 
            
            
         /*      Print overridden methods     */   
         
        printf("-metode supraincarcate: %d\n",ow_methods);
        for(k = contor5 ; k < contor5+methAux ; k++)
        {
             if(strcmp(M[k],"Wrong") != 0) 
                printf("\t%s\n",M[k]);
        }
        
     
        printf("\n");
        
        ow_methods = 0;
        methAux = 0;
        dup_methods = 0;
        
    }
    
    fclose(yyin);
    return 0;
}  