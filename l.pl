#!/usr/local/bin/perl
use strict;

#use Term::ANSIScreen qw/:color :cursor :screen/; #http://search.cpan.org/~jlmorel/Win32-Console-ANSI-1.04/lib/Win32/Console/ANSI.pm
#use Win32::Console::ANSI;                        #Colors!
# Term::ANSIScreen::colored($buffer[$x][$y], 'red');

my $space = " "; #shell
my $break = "\n"; #shell
if (0)
{
	$space = "&nbsp;"; #convert to web if needed
	$break = "</BR>\n"; #web
}

# HTTP HEADER
print("Content-type: text/html \n\n");
print("<HTML>\n");
print('<BODY style="font-family: new courier;">' . "\n");

my $scr = new display(32,24);

$scr->point(0,0);
$scr->point($scr->getMaxX(),$scr->getMaxY());
$scr->box(5,8,18,14);
$scr->line(14,2,29,10);
$scr->line(0,2,4,16);
$scr->circle(25,19,5);
$scr->printscreen();

print("</BODY>\n");
print("</HTML>\n");


package display;

my @buffer = (); #screen buffer
my $size_w = 0;
my $size_h = 0;

sub new
{
	my ($class, $width, $height) = @_;
	my $self = {};
	bless $self, $class;
	
	$size_w = $width;
	$size_h = $height;

	for(my $y; $y<$height; $y++)
	{
	  for(my $x; $x<$width; $x++)
	  {
		$buffer[$x][$y] = $space;
	  }
	}
	return $self;
}

sub printscreen()
{
	my $self = shift;

	printf("%s%s%s", $space, $space, $space);
	for(my $x=0; $x<$size_w; $x++)
	{
		printf("%s%i", $x<10?$space:"", $x);
	}
	printf("%s", $break);

	for(my $y=0; $y<$size_h; $y++)
	{
		printf("%s%d ", ($y<$size_w)?$space:"", $y);
		for(my $x=0; $x<32; $x++)
		{
			if ($buffer[$x][$y] eq ' ')
			{
				printf("%s%s", $space, $space);
			}
			else
			{
				printf("%s%s", $buffer[$x][$y], $space);
			}
		}
		printf("%s", $break);
	}
}

sub point()
{
	my ( $self, $x, $y) = @_;
	if($x<$size_w && $x >=0 && $y< $size_h && $y>=0)
	{
		$buffer[$x][$y] = '@';
	}
	else
	{
		die ("Error - drawing out of bounds\n");
	}
	
}

sub box()
{
	my ( $self, $x1, $y1, $x2, $y2) = @_;
	#printf("box:  %i %i %i %i\n", $x1, $y1, $x2, $y2);
	$self->line ($x1,$y1,$x2,$y1); #top
	$self->line ($x1,$y2,$x2,$y2); #bottom
	$self->line ($x1,$y1,$x1,$y2); #left
	$self->line ($x2,$y1,$x2,$y2); #right
}


sub line()
{
	my ( $self, $x1, $y1, $x2, $y2) = @_;

	#printf("lne:  %i %i %i %i\n", $x1, $y1, $x2, $y2);
	if( $x1 == $x2)
	{
		for(my $y=$y1; $y<=$y2; $y++)
		{
			$self->point($x1, $y);
		}
	}
	elsif( $y1 == $y2)
	{
		#print("here");
		for(my $x=$x1; $x<=$x2; $x++)
		{
			$self->point($x, $y1);
		}
	}
	else
	{
		my $m = ($y2 - $y1) / ($x2 - $x1);
		my $b = -($m * $x1 - $y1);
		my $stepSize = 1/$m > 1 ? 1 : 1/$m;
		for(my $x = $x1; ($x2>$x1) ? $x <= $x2 : $x >= $x1; ($x+=$stepSize))
		{
			my $y = $x * $m + $b;
			$self->point($x, $y);
		}
	}
}

sub circle()
{
	my ( $self, $x_center, $y_center, $r) = @_;

	for(my $i=0; $i<=(2*3.14159); $i+=0.1)
	{
		my $x = $x_center + cos($i) * $r;
		my $y = $y_center + sin($i) * $r;
		
	  $self->point($x, $y);
	}
}

sub getMaxX()
{
	my ( $self ) = @_;
	  return $size_w - 1;
}

sub getMaxY()
{
	my ( $self ) = @_;
	  return $size_h - 1;
}