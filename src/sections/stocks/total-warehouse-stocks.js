import { Card, CardContent ,Stack, SvgIcon, Typography} from '@mui/material'
import React from 'react'

const WarehouseStocks = () => {
  return (
    <Card>
        <CardContent>
            <Stack direction="row" justifyContent="space-between">
                <Stack spacing={2}>
                    <Typography variant='h4'>The rex randy show</Typography>
                    <SvgIcon>
                        
                    </SvgIcon>
                </Stack>
            </Stack>
        </CardContent>
    </Card>
  )
}

export default WarehouseStocks