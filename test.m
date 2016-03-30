clc
clear
x1=[zeros(1,1631)];

for n=1:31
    if n==1
        x1(n)=1;
    else
        x1(n)=0;
    end
end

for i=(2^13-1):-1:0
     x2_=dec2bin(i,31)-48;
     for j=1:31
         xx(j)=x2_(j)*2^(31-j);
     end
         C=sum(xx)
         if(C==7168)
             fprintf('STOP')
             x2_
             break
         end
end
for i=1:31
    x2(i)=x2_(32-i);
end
x2
for n=1:1600
    x1(n+31)=mod((x1(n+3)+x1(n)),2);
    x2(n+31)=mod(x2(n+3)+x2(n+2)+x2(n+1)+x2(n),2);
end


for n=1:1:25
    c(n)=mod(x1(n+1600)+x2(n+1600),2);
end
for m=1:1:12
    r(m)=1/(2^0.5)*(1-2*c(2*m-1))+j*(1/(2^0.5))*(1-2*c(2*m+1-1));
end

