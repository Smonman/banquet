%
% Author: Simon J. Kreuzpointner
% Date: 2023/08/29
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{banquet}[2023/08/30 Banquet LaTeX class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage[a4paper,top=3cm,bottom=2cm,left=2cm,right=2cm,headsep=1cm]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{babel}
\RequirePackage{pgf}
\RequirePackage{pgfkeys}
\RequirePackage{pgffor}
\RequirePackage{pgfmath}
\RequirePackage{siunitx}
\RequirePackage{eurosym}
\RequirePackage{tabularx}
\RequirePackage{pdftexcmds}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage{fancyhdr}
\RequirePackage{xstring}

%
% key setup
%

% ifs
\newif\ifbqshowprice
\newif\ifbqshowdecimals
\newif\ifbqshowcurrencysymbol
\newif\ifbqshowallergens
\newif\ifbqshowfill
\newif\ifbqorganic
\newif\ifbqvegetarian
\newif\ifbqvegan
\newif\ifbqhalal
\newif\ifbqkosher
\newif\ifbqglutenfree
\newif\ifbqshowbadge
\newif\ifbqshowservingsize
\newif\ifbqshowservingsizeunit
\newif\ifbqshowprefix
\newif\ifbqusesectionprefix
\newif\ifbqshownumberingmajor
\newif\ifbqshownumberingminor

% general keys
\pgfkeys{%
	/banquet/.cd,
	restaurant/.store in=\bqrestaurant,
	restaurant={},
	title/.code={\title{#1}},
	author/.code={\author{#1}},
	dish/padding/top/.store in=\bqdishpaddingtop,
	dish/padding/top={0em},
	dish/padding/bottom/.store in=\bqdishpaddingbottom,
	dish/padding/bottom={0.5em},
	price/show/.is if=bqshowprice,
	price/show=true,
	price/decimals/show/.is if=bqshowdecimals,
	price/decimals/show=true,
	price/currency symbol/.store in=\bqcurrencysymbol,
	price/currency symbol={},
	price/currency symbol/show/.is if=bqshowcurrencysymbol,
	ingredients/delimiter/.store in=\bqingredientsdelimiter,
	ingredients/delimiter={,\bqprintstandardspace},
	allergens/show/.is if=bqshowallergens,
	allergens/show=true,
	allergens/delimiter/.store in=\bqallergensdelimiter,
	allergens/delimiter={,\bqprintstandardspace},
	badge/show/.is if=bqshowbadge,
	badge/show=false,
	fill/show/.is if=bqshowfill,
	fill/show=true,
	fill/symbol/.store in=\bqfillsymbol,
	fill/symbol={.},
	prefix/show/.is if=bqshowprefix,
	prefix/show=false,
	prefix/use section/.is if=bqusesectionprefix,
	numbering/major/show/.is if=bqshownumberingmajor,
	numbering/major/show=false,
	numbering/major/.code=\setcounter{bqmajor}{#1},
	numbering/minor/show/.is if=bqshownumberingminor,
	numbering/minor/show=false,
}

% dish specific keys
\pgfkeys{%
	/banquet/dish/current/.cd,
	name/.store in=\bqname,
	name/.value required,
	ingredients/.store in=\bqingredients,
	ingredients={},
	allergens/.store in=\bqallergens,
	allergens={},
	badge/organic/.is if=bqorganic,
	badge/organic=false,
	badge/vegetarian/.is if=bqvegetarian,
	badge/vegetarian=false,
	badge/vegan/.is if=bqvegan,
	badge/vegan=false,
	badge/halal/.is if=bqhalal,
	badge/halal=false,
	badge/kosher/.is if=bqkosher,
	badge/kosher=false,
	badge/gluten free/.is if=bqglutenfree,
	badge/gluten free=false,
	price/.store in=\bqprice,
	price/.default=0,
	price=0,
	serving size/.store in=\bqservingsize,
	serving size/show/.is if=bqshowservingsize,
	serving size/show=false,
	serving size/unit/.store in=\bqservingsizeunit,
	serving size/unit/show/.is if=bqshowservingsizeunit,
	serving size/unit/show=true,
	prefix/.store in=\bqprefix,
	prefix={},
	numbering/minor/.code=\setcounter{bqminor}{#1},
}

%
% article setup
%

\author{}
\date{}
\title{}

%
% Other setup
%
\setcounter{secnumdepth}{-1} % remove section numbering

% setup section
\titleformat{\section}[block]{\Large\bfseries\filcenter}{\thesection}{1em}{}%
\titlespacing{\section}{0pt}{*5}{*2}

% setup subsection
\titleformat{\subsection}[block]{\large\bfseries\filcenter}{\thesubsection}{1em}{}%
\titlespacing{\subsection}{0pt}{*2}{*1.5}

% title
\pretitle{%
	\begin{center}%
		\Huge%
		}%
		\posttitle{%
	\end{center}%
	\vskip .75em plus .25em minus .25em%
}%

% author
\preauthor{}%
\postauthor{}%

% date
\predate{}%
\postdate{}%

% setup header and footer
\pagestyle{fancy}%
\renewcommand{\headrulewidth}{0pt}%
\fancyhf{}%

% for the first page, if maketitle is used
\fancypagestyle{plain}{%
	\renewcommand{\headrulewidth}{0pt}%
	\fancyhf{}%
}

% set for for units and numbers
\sisetup{mode=text}%

% setup counters
\newcounter{bqmajor}
\newcounter{bqminor}[bqmajor]

%
% Commands
%

% a reference for the dollar
\newcommand{\dollar}{%
	\$%
}

% the current section
\newcommand{\bqcurrentsection}[1]{%
	#1%
}

% gets the first letter
\newcommand{\bqextractfirstletter}[1]{%
	\StrRemoveBraces{#1}[\firstletter]%
	\StrChar{\firstletter}{1}[\firstletter]%
	\edef\bqprintfirstletter{\firstletter}%
}

% section command that increments the major counter
\newcommand{\bqsection}[1]{%
	\section{#1}%
	\stepcounter{bqmajor}%
	\renewcommand{\bqcurrentsection}{#1}%
}

% prints a standard space
\newcommand{\bqprintstandardspace}{%
	\;%
}

% set keys for the whole document
\newcommand{\bqset}[1][]{%
	\pgfkeys{/banquet/.cd,#1}%
}

% create and print a new dish
\newcommand{\bqdish}[1][]{%
	\begingroup%
	\pgfkeys{/banquet/dish/current/.cd,#1}%
	\par\noindent%
	\vskip \bqdishpaddingtop%
	\bqprintdish%
	\vskip \bqdishpaddingbottom%
	\endgroup%
	\stepcounter{bqminor}%
}

% prints the current dish
\newcommand{\bqprintdish}{%
	\begingroup%
	\noindent%
	\setlength{\tabcolsep}{0pt}%
	\begin{tabularx}{\columnwidth}{lrrlXlr}%
		\bqprintprefix & \bqprintnumberingmajor & \bqprintnumberingminor & \bqprintname\bqprintallergens\bqprintbadges & {\bqprintfill} & \bqprintservingsize & \bqprintprice %
	\end{tabularx}%
	\bqprintingredients%
	\endgroup%
}

% print the name of the current dish
\newcommand{\bqprintname}{%
	\textbf{\bqname}%
}

% print all ingredients
\newcommand{\bqprintingredients}{%
	\begingroup%
	\bqprintifnotempty{\bqingredients}{%
		\newline%
	}%
	\foreach \ingredient [count=\i] in \bqingredients {%
		\ifnum\i=1%
			\bqprintingredient{\ingredient}%
		\else%
			\bqprintingredientdelimiter\bqprintingredient{\ingredient}%
		\fi%
	}%
	\endgroup%
}

% print a single ingredient, that is passed in
\newcommand{\bqprintingredient}[1]{%
	#1%
}

% print the delimiter fo the ingredient
\newcommand{\bqprintingredientdelimiter}{%
	\bqingredientsdelimiter%
}

% prints all allergens
\newcommand{\bqprintallergens}{%
	\begingroup%
	\ifbqshowallergens%
		\bqprintspacingifnotempty{\bqallergens}%
		\foreach \allergen [count=\i] in \bqallergens {%
			\ifnum\i=1%
				\bqprintallergen{\allergen}%
			\else%
				\bqprintallergendelimiter\bqprintallergen{\allergen}%
			\fi%
		}%
	\fi%
	\endgroup%
}

% print the given allergen
% this calls the underlying print command for the given allergen
\makeatletter
\newcommand{\bqprintallergen}[1]{%
	\ifnum\pdf@strcmp{A}{#1}=0%
		\bqprintallergena%
	\else%
		\ifnum\pdf@strcmp{B}{#1}=0%
			\bqprintallergenb%
		\else%
			\ifnum\pdf@strcmp{C}{#1}=0%
				\bqprintallergenc%
			\else%
				\ifnum\pdf@strcmp{D}{#1}=0%
					\bqprintallergend%
				\else%
					\ifnum\pdf@strcmp{E}{#1}=0%
						\bqprintallergene%
					\else%
						\ifnum\pdf@strcmp{F}{#1}=0%
							\bqprintallergenf%
						\else%
							\ifnum\pdf@strcmp{G}{#1}=0%
								\bqprintallergeng%
							\else%
								\ifnum\pdf@strcmp{H}{#1}=0%
									\bqprintallergenh%
								\else%
									\ifnum\pdf@strcmp{L}{#1}=0%
										\bqprintallergenl%
									\else%
										\ifnum\pdf@strcmp{M}{#1}=0%
											\bqprintallergenm%
										\else%
											\ifnum\pdf@strcmp{N}{#1}=0%
												\bqprintallergenn%
											\else%
												\ifnum\pdf@strcmp{O}{#1}=0%
													\bqprintallergeno%
												\else%
													\ifnum\pdf@strcmp{P}{#1}=0%
														\bqprintallergenp%
													\else%
														\ifnum\pdf@strcmp{R}{#1}=0%
															\bqprintallergenr%
														\else%nothing
														\fi%
													\fi%
												\fi%
											\fi%
										\fi%
									\fi%
								\fi%
							\fi%
						\fi%
					\fi%
				\fi%
			\fi%
		\fi%
	\fi%
}
\makeatother

% prints the allergen A
\newcommand{\bqprintallergena}{%
	\bqprintallergengeneric{A}%
}

% prints the allergen B
\newcommand{\bqprintallergenb}{%
	\bqprintallergengeneric{B}%
}

% prints the allergen C
\newcommand{\bqprintallergenc}{%
	\bqprintallergengeneric{C}%
}

% prints the allergen D
\newcommand{\bqprintallergend}{%
	\bqprintallergengeneric{D}%
}

% prints the allergen E
\newcommand{\bqprintallergene}{%
	\bqprintallergengeneric{E}%
}

% prints the allergen F
\newcommand{\bqprintallergenf}{%
	\bqprintallergengeneric{F}%
}

% prints the allergen G
\newcommand{\bqprintallergeng}{%
	\bqprintallergengeneric{G}%
}

% prints the allergen H
\newcommand{\bqprintallergenh}{%
	\bqprintallergengeneric{H}%
}

% prints the allergen L
\newcommand{\bqprintallergenl}{%
	\bqprintallergengeneric{L}%
}

% prints the allergen M
\newcommand{\bqprintallergenm}{%
	\bqprintallergengeneric{M}%
}

% prints the allergen N
\newcommand{\bqprintallergenn}{%
	\bqprintallergengeneric{N}%
}

% prints the allergen O
\newcommand{\bqprintallergeno}{%
	\bqprintallergengeneric{O}%
}

% prints the allergen P
\newcommand{\bqprintallergenp}{%
	\bqprintallergengeneric{P}%
}

% prints the allergen R
\newcommand{\bqprintallergenr}{%
	\bqprintallergengeneric{R}%
}

% prints the given allergen
\newcommand{\bqprintallergengeneric}[1]{%
	{\footnotesize #1}%
}

% prints the delimiter for the allergen
\newcommand{\bqprintallergendelimiter}{%
	\bqallergensdelimiter%
}

% prints the serving size of the current dish
\newcommand{\bqprintservingsize}{%
	\ifbqshowservingsize%
		\qty{\bqservingsize}{\bqprintservingsizeunit}%
		\quad\null%
	\fi%
}

% prints the serving size unit
\newcommand{\bqprintservingsizeunit}{%
	\ifbqshowservingsizeunit%
		\bqservingsizeunit%
	\fi%
}

% prints the price of the current dish
\newcommand{\bqprintprice}{%
	\ifbqshowprice%
		\bqprintcurrencysymbol%
		\num[%
			round-precision={\bqprintshowdecimals},
			round-mode=places
		]{\bqprice}
	\fi%
}

% print the number of decimals that should be shown for the price of the current
% dish
\newcommand{\bqprintshowdecimals}{%
	\ifbqshowdecimals%
		2%
	\else%
		0%
	\fi%
}

% print the currency symbol that should be shown for the price of the current
% dish
\newcommand{\bqprintcurrencysymbol}{%
	\ifbqshowcurrencysymbol%
		{\bqcurrencysymbol\bqprintstandardspace}%
	\else%nothing
	\fi%
}

% print a fill of \bqfillsymbol
\newcommand{\bqprintfill}{%
	\ifbqshowfill%
		\bqfillsymbol%
		\unskip\nobreak\leaders\hbox{\bqfillsymbol}\hfill\relax%
		\null%
	\else%nothing
	\fi%
}

% prints all badges
\newcommand{\bqprintbadges}{%
	\ifbqshowbadge%
		\bqprintorganic%
		\bqprintvegetarian%
		\bqprintvegan%
		\bqprinthalal%
		\bqprintkosher%
		\bqprintglutenfree%
	\fi%
}

% prints the organic badge
\newcommand{\bqprintorganic}{%
	\ifbqorganic%
		\bqprintstandardspace\textit{organic}%
	\fi%
}

% prints the vegetarian badge
\newcommand{\bqprintvegetarian}{%
	\ifbqvegetarian%
		\bqprintstandardspace\textit{vegetarian}%
	\fi%
}

% prints the vegan badge
\newcommand{\bqprintvegan}{%
	\ifbqvegan%
		\bqprintstandardspace\textit{vegan}%
	\fi%
}

% prints the halal badge
\newcommand{\bqprinthalal}{%
	\ifbqhalal%
		\bqprintstandardspace\textit{halal}%
	\fi%
}

% prints the kosher badge
\newcommand{\bqprintkosher}{%
	\ifbqkosher%
		\bqprintstandardspace\textit{kosher}%
	\fi%
}

% prints the gluten free bade
\newcommand{\bqprintglutenfree}{%
	\ifbqglutenfree%
		\bqprintstandardspace\textit{gluten free}%
	\fi%
}

% prints the second parameter if the first is not {}
\newcommand{\bqprintifnotempty}[2]{%
	\if\relax#1\relax%
		% empty
	\else%
		#2%
	\fi%
}

% prints a spacing if the given parameter is not {}
\newcommand{\bqprintspacingifnotempty}[1]{%
	\bqprintifnotempty{#1}{\bqprintstandardspace}%
}

% prints the prefix
\newcommand{\bqprintprefix}{%
	\ifbqshowprefix%
		\ifbqusesectionprefix%
			\bqprintsectionprefix%
		\else%
			\bqprefix%
			\bqprintspacingifnotempty{\bqprefix}%
		\fi%
	\fi%
}

% prints the section prefix
\newcommand{\bqprintsectionprefix}{%
	\if\relax\bqcurrentsection\relax%
	\else%
		\bqextractfirstletter{\expandafter\bqcurrentsection}%
		\MakeUppercase{\bqprintfirstletter}%
		\bqprintstandardspace%
	\fi%
}

% print major numbering
\newcommand{\bqprintnumberingmajor}{%
	\ifbqshownumberingmajor
		\thebqmajor\bqprintstandardspace%
	\fi%
}

% print minor numbering
\newcommand{\bqprintnumberingminor}{%
	\ifbqshownumberingminor
		\thebqminor\bqprintstandardspace%
	\fi%
}