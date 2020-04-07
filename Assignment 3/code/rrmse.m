function val = rrmse(A, B)
    ssum = sum(sum((A - B).^2));
    val = sqrt(ssum)/sqrt(sum(sum(A.^2)));
end