printf("%f\n", filter_H(1, 1, 15) );

sub filter_H
{
 my ($x, $i, $k) = @_;
 my $k_sum = 0.0;
 for(my $count_k = 0; $count_k <= $k; $count_k++)
 {
	$k_sum += $x * ($i-$count_k);
 }
 return ((1.0/16.0) * $k_sum);
}
