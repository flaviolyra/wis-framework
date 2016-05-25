# -*- coding: utf-8 -*-
"""
/***************************************************************************
 MontanteJusante
                                 A QGIS plugin
 ao clicar trecho de hidrografia, mostra bacia montante e curso jusante
                             -------------------
        begin                : 2015-09-16
        copyright            : (C) 2015 by Flavio J. Lyra
        email                : flavio.jose.lyra@gmail.com
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load MontanteJusante class from file MontanteJusante.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .montante_jusante import MontanteJusante
    return MontanteJusante(iface)
