

# SUPER DADA for Dataverse versions 4+

SUPER DADA is a bash script that adapts XML-DDI metadata files produced by Dataverse in order to make them compliant with the technical requirements of the [CESSDA Data Catalogue](https://datacatalogue.cessda.eu/) (CDC).

'SUPER DADA' stands for **S**cript for **Up**dating **E**lectronic **R**ecords: From **Da**taverse to CESS**DA**.

This version of the script is geared towards **versions 4+** of Dataverse.

The script was developed and documented in April-May 2021 by Youssef Ouahalou with the help of Benjamin Peuch for the [SODHA repository](https://www.sodha.be/) at the [State Archives of Belgium](http://www.arch.be/index.php?l=en). The second version was completed in June-July 2021.

## Version history and project status

This is the **second version** of SUPER DADA for **versions 4+** of Dataverse: **SUPER DADA v2.0**

<span style="color:red">**IMPORTANT NOTE: Please do not use SUPER DADA for Dataverse 4+ <u>v1.0</u>. It turns out the first version of the script is problematic due to unfortunate misinterpretations of the Metadata Validator's constraint violations.**</span>

This new version of the script includes both:

 1. A **fixed version of the script**, which properly modifies Dataverse-produced XML-DDI metadata records to make them compliant with the basic level of validation of the [CESSDA Metadata Validator](https://cmv.cessda.eu/#!validation) for the [CESSDA Data Catalogue (CDC) DDI 2.5 Profile 1.0.4](https://zenodo.org/record/4050124);

 2. A **patch** for 'fixing' metadata records on which version 1.0 of SUPER DADA has been run.

If you run into issues with the script, please don't hesitate to reach us at sodha@arch.be.

The next section features a list of problems uncovered in version 1.0 of the script.

## Version 2.0 fixes

If you have run v1.0 of the script on your collections, the problems listed below will be solved by running the file ``Patch_for_SUPER_DADA_v1_0.sh``.

Naturally, v2.0 of the script, i.e. the file ``SUPER_DADA_DV_5_v2_0_script.sh`` does everything properly, and there is no need to run the patch if you've never run v1.0. 

- ``@lang`` → ``@xml:lang``

It was previously thought that several elements required the ``@lang`` attribute to be validated against the CDC. However, the proper attribute is ``@xml:lang``.

- ``<titl>`` – ``<timeMeth>`` – ``<restrctn>``

Besides, three elements which should also have received this attribute did not in v1.0. They are now included in the script's list of targets. The elements in question are:

 1. ``<titl>``, both the one in ``<docDscr>`` and the other in ``<stdyDscr>``
 2. ``<timeMeth>``
 3. ``<restrctn>``

- ``<distDate>`` + ``@date``

The script was previously said to add a ``<distDate>`` element in ``<stdyDscr>`` but it did not do so properly. It now does. Both the ``<distDate>`` element and its ``@date`` attribute receive as a value the date contained in the  ``<distDate>`` element present by default in ``<docDscr>``.


## What the script does

In its current state, SUPER DADA modifies XML-DDI files produced by a version 4+ Dataverse installation so that they become fully compliant with the 'BASIC' level of validation (or 'validation gate') of the [CESSDA Metadata Validator](https://cmv.cessda.eu/#!validation) against the [CESSDA Data Catalogue (CDC) DDI 2.5 Profile 1.0.4](https://zenodo.org/record/4050124).

<span style="color:red">**WARNING: This script <u>overwrites</u> the contents of metadata export files. It does not create separate, edited copies of the files. Consider making an apart backup of your metadata before running the script.**</span>

As per the CDC requirements, which stem from the [CESSDA Metadata Model](https://zenodo.org/record/3547513), SUPER DADA adds

- **elements**
  - ``<holdings>``
  - ``<distDate>``

- and **attributes**
  - ``@xml:lang``
  - ``@lang``
  - ``@vocab``
  - ``@URI`` (in ``<holdings>``)
  - ``@date`` (in ``<distDate>``) 

which are either not present by default in the DDI files produced by Dataverse or not present at the right place according to [the profile's specifications](https://zenodo.org/record/4050124).

## Prerequisites

Because this script is tailored for Dataverse, you need to run it on **Linux CentOS 7**.

Place the script anywhere on the server where you have installed Dataverse, preferably in the GlassFish directory.

The user who executes the script must have **access to the folders** in which the export metadata files are stored.

The script relies heavily on **[XMLStarlet](http://xmlstar.sourceforge.net/)**, a set of command line utilities for editing XML files which you will need to download and install.

The script will fetch the export metadata files where they are created with **default file storage**, i.e. "file (Default)." Adjustments might be required with other storage modes (AWS, etc.).

## Two steps

First, you will need to run the script without the **``-mtime`` parameter** in order to edit all of your metadata export files.

Then you can set it to run periodically with said parameter so that only the most recent files are modified (see comments in the code).

## License and disclaimer

[MIT License](https://choosealicense.com/licenses/mit/)

Copyright © 2021 State Archives of Belgium

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The Software is provided "as is," without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.

## Proprietary rights

The **Dataverse** software was developed by the [Institute for Quantitative Social Science](https://www.iq.harvard.edu/) (IQSS) of Harvard University. Dataverse is made available for reuse under an Apache 2 license which can be consulted on [GitHub](https://github.com/IQSS/dataverse/blob/master/LICENSE.md). See also [[1]](https://dataverse.org/publications/introduction-dataverse-network-infrastructure-data-sharing) and [[2]](https://dataverse.org/publications/dataverse-network-open-source-application-sharing-discovering-and) for further information.

**XMLStarlet** was developed by Mikhail Grushinskiy and is made available for reuse under an MIT license which can be consulted on [Sourceforge](http://xmlstar.sourceforge.net/license.php).

The **CESSDA Data Catalogue** is an online tool and service developed by the [Consortium of European Social Science Data Archives](https://www.cessda.eu/) (CESSDA ERIC) which is governed by an [Acceptable Use Policy and Conditions of Use](https://www.cessda.eu/Acceptable-Use-Policy).
