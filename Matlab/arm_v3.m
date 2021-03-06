%-----------------------------------------
% Ber�knar h�varmsr�relse fr�n servo r�relse
%
%
%skriven av Joakim Olsson 2013-03-21
%------------------------------------------



clc
close all 
clear ala variables

%itteration or not
IT_ON=true;    %v�lj true om gamma ska ittereras fram (ger exakr v�rde)

L2=10*10^-2;   %x-komp mellan origo och punkt p3(finger) 
a=4*10^-2;     %arm mellan origo och p1
b=8*10^-2;     %arm mellan p2 och p3
h=-0*10^-2;    %y-komp mellan origo och punkt p3(finger)

%Definition av L1   
x1=a*sin(-60*(pi/180));  %start koordinater f�r p1 och p2
y1=a*cos(-60*(pi/180));
x2=L2; 
y2=h+b;

L1=sqrt((x1-x2)^2+(y1-y2)^2); % Avst�ndsformel

%Fasta punkter
p0=[0,0]; 
p3=[L2,h];

I=121; %Antal steg theta delas upp i (SE FOR LOOP)
hold on


%For-loop f�r att ber�kna gamma och punkterna p1 och p2 utifr�n theta 
for i=0:I
    
    theta=(i-floor(I/2))*(pi/180);          %definerar upp servovinkeln mellan -60 och 60 grader
    
    if IT_ON==0
    gamma=(60+theta*(180/pi))*3/4*(pi/180); % en oexakt approximation av gamma
    else
    
    %koordinaterna f�r punkt 1    
    x1=a*sin(theta);   
    y1=a*cos(theta);
   
    %itteration of GAMMA
    
    gamma=(60+theta*(180/pi))*3/4*(pi/180);  %Gissat v�rde
    GAMMA_A(i+1)=gamma*(180/pi);             %Sparar initierat v�rde av gamma
    p1=[x1,y1];          
    p2=[L2+b*sin(gamma),h+b*cos(gamma)];     %ber�knar punkt p2 med v�rt approximerade gamma
    L1_a=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2); %Ber�knar avst�ndet mellan v�ra punkter
    it=1;                                    %H�ller koll p� antalet itterationer
    tol=10^-3;                               %Tolerans f�r skillnaden mellan ber�knat L1 och det ricktiga L1
    K=200;                                   %Itterations tollerans
    
    %Itteration av gamma
    while abs(L1-L1_a)>tol                   %Checkar om approximationen st�mmer        
        
        if it<K                              %Om loopen har k�rts mindre �n K stiger gamma p� f�r att htta det korrekta
        it=it+1;
        gamma=gamma+0.1*(pi/180);
        p1=[a*sin(theta),a*cos(theta)];
        p2=[L2+b*sin(gamma),h+b*cos(gamma)];
        L1_a=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
        
        else 
        it=it+1;                             %Om itterationen �r �ver K l�g antagligen det korrekta gamma under det ursprungliga
        gamma=gamma-0.1*(pi/180);            %Gamma s�nks f�r att hitta det korrekta
        p1=[a*sin(theta),a*cos(theta)];
        p2=[L2+b*sin(gamma),h+b*cos(gamma)];
        L1_a=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
            
        end
        IT(i+1)=it;                           %Sparar antalet itterationer
    end
    
    
    end
    
    
    THETA(i+1)=theta*(180/pi);                 %Sparar theta vinklarna
    GAMMA(i+1)=gamma*(180/pi);                 %Sparar gamma vinklarna
    
    %sparar koordinaterna f�r samtliga punkter
    P0(i+1,:)=p0;
    P1(i+1,:)=[a*sin(theta),a*cos(theta)]; 
    P2(i+1,:)=[L2+b*sin(gamma),p3(2)+b*cos(gamma)];
    P3(i+1,:)=p3;
    

end 


t=0.2;    %Axis-span
   
%Plott
for i=1:I
    
    clf
    axis([-t t -t t])
    axis equal
    hold on 
      
    %Plottar ut punkterna
    plot([P0(i,1) P1(i,1)],[P0(i,2) P1(i,2)])
    plot([P1(i,1) P2(i,1)],[P1(i,2) P2(i,2)])
    plot([P2(i,1) P3(i,1)],[P2(i,2) P3(i,2)])
    
    %plottar ut p1 och p2's banor
    plot(P1(:,1),P1(:,2),'k')
    plot(P2(:,1),P2(:,2),'k')
    
    
    pause(0.01)
    
    L1(i)=sqrt((P1(i,1)-P2(i,1))^2+(P1(i,2)-P2(i,2))^2);
    
    grid on
end





