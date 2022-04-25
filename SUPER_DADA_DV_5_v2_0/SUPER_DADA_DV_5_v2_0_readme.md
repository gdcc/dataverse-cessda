# SUPER DADA for Dataverse versions 5+

SUPER DADA is a bash script that adapts XML-DDI metadata files produced by Dataverse in order to make them compliant with the technical requirements of the **[CESSDA Data Catalogue](https://datacatalogue.cessda.eu/)** (CDC).

'SUPER DADA' stands for **S**cript for **Up**dating **E**lectronic **R**ecords: From **Da**taverse to CESS**DA**.

This version of the script is geared towards **versions 5+** of Dataverse.

Development and documentation of the script were completed in April 2022 by Youssef Ouahalou with the help of Benjamin Peuch for the **[SODHA repository](https://www.sodha.be/)** at the **[State Archives of Belgium](http://www.arch.be/index.php?l=en)**.

## Version history and project status

This is the **second version** of SUPER DADA for **versions 5+** of Dataverse: <span style="color:green">**SUPER DADA v2.0**</span>

Another, similar version of the script exists for **versions 4+** of Dataverse.

This new version of the script includes both:

 1. An **improved version of the script**, which adds **country codes** in the ``@abbr`` attribute of ``<nation>`` elements so that they can be detected by the CDC as instances of countries;

 2. A **patch** for retroactively adding country codes to <nation> elements in metadata files which have **already been modified** by SUPER DADA for Dataverse 5+ version 1.0.

If you have already run v1.0 of the script on your metadata, just running version 2.0 will not add country codes on metadata that have already been modified.

To ensure that country codes are added to all of your metadata files, you need to run the **patch**. After that, you can simply have version 2.0 of the script regularly updating your incoming metadata in the background without the need to run the patch ever again.

If you run into issues with the script, please don't hesitate to reach us at sodha@arch.be.

## What the script does

In its current state, SUPER DADA modifies XML-DDI files produced by a version 5+ Dataverse installation so that the files become fully compliant with the 'BASIC' level of validation (or 'validation gate') of the [CESSDA Metadata Validator](https://cmv.cessda.eu/#!validation) against the [CESSDA Data Catalogue (CDC) DDI 2.5 Profile 1.0.4](https://zenodo.org/record/4050124).

<span style="color:red">**WARNING: This script <u>overwrites</u> the contents of metadata export files. It does not create separate, edited copies of the files. Consider backing up your metadata before running the script.**</span>

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
  - ``@abbr`` (in ``<nation>``)

which are either not present by default in the DDI files produced by Dataverse or not present at the right place according to [the profile's specifications](https://zenodo.org/record/4050124).

## Prerequisites

Because this script is tailored for Dataverse, you need to run it on **Linux CentOS 7**.

Place the script anywhere on the server where you have installed Dataverse, preferably in the Payara (formerly, GlassFish) directory.

The user who executes the script must have **access to the folders** in which the export metadata files are stored.

The script relies heavily on **[XMLStarlet](http://xmlstar.sourceforge.net/)**, a set of command line utilities for editing XML files which you will need to download and install.

The script will fetch the export metadata files where they are created with **default file storage**, i.e. "file (Default)." Adjustments might be required with other storage modes (AWS, etc.).

## Two steps

First, you will need to run the script without the **``-mtime`` parameter** in order to edit all of your metadata export files.

Then you can set it to run periodically with said parameter so that only the most recent files are modified (see comments in the code).

## License and disclaimer

[MIT License](https://choosealicense.com/licenses/mit/)

Copyright © 2022 State Archives of Belgium

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The Software is provided "as is," without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.

## Proprietary rights

The **Dataverse** software was developed by the [Institute for Quantitative Social Science](https://www.iq.harvard.edu/) (IQSS) of Harvard University. Dataverse is made available for reuse under an Apache 2 license which can be consulted on [GitHub](https://github.com/IQSS/dataverse/blob/master/LICENSE.md). See also [[1]](https://dataverse.org/publications/introduction-dataverse-network-infrastructure-data-sharing) and [[2]](https://dataverse.org/publications/dataverse-network-open-source-application-sharing-discovering-and) for further information.

**XMLStarlet** was developed by Mikhail Grushinskiy and is made available for reuse under an MIT license which can be consulted on [Sourceforge](http://xmlstar.sourceforge.net/license.php).

The **CESSDA Data Catalogue** is an online tool and service developed by the [Consortium of European Social Science Data Archives](https://www.cessda.eu/) (CESSDA ERIC) which is governed by an [Acceptable Use Policy and Conditions of Use](https://www.cessda.eu/Acceptable-Use-Policy).
