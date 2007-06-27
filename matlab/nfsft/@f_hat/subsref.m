function b = subsref(p,s)
% Indexing funcction for f_hat class.
%
% Copyright 2007 Jens Keiner

switch s.type
case '()'
  if (length(s.subs) > 2)
    error('Index must consist of two elements.');
  end

  ind1 = s.subs{1};
  ind2 = s.subs{2};

  if (any(round(ind1) ~= ind1) || min(ind1) < 0 || max(ind1) > p.N)
    error('Invalid index in first component');
  end

  if (any(round(ind2) ~= ind2) || min(ind2) < -p.N || max(ind2) > p.N)
    error('Invalid index in second component');
  end

  if (length(ind1) == 1 && min(ind2) >= -ind1 && max(ind2) <= ind1)
    if (ind1 == 0)
      o = 0;
    else
      o = ind1^2;
    end
    b = p.f_hat(o+ind1+1+ind2);
  elseif (length(ind2) == 1 && min(ind1) >= abs(ind2))
    b = zeros(size(ind1));
    for k = 1:length(ind1)
      b(k) = p.f_hat(ind1(k)^2+ind1(k)+1+ind2);
    end
  else
    error('Invalid subindex');
  end
otherwise
  error('Wrong subindex format');
end