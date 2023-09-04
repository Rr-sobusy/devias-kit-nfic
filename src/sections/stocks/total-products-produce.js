import React from 'react'
import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import Produced from "@heroicons/react/24/solid/ArchiveBoxArrowDownIcon";
import Proptypes from 'prop-types'
const TotalProduced = ({beginningDate, value}) => {
  return (
    <Card>
    <CardContent>
      <Stack spacing={3} direction="row" justifyContent="space-between">
        <Stack spacing={2}>
            <Typography color="text.secondary" variant="overline">
              Products produced
            </Typography>            
            <Typography variant="h4">
           {value} KT
            </Typography>
            <Typography variant='caption' color="text.secondary">Since {beginningDate}</Typography>
        </Stack>
        <Avatar sx={{ bgcolor: "#F0DE36", height: 56, width: 56 }}>
          <SvgIcon>
            <Produced />
          </SvgIcon>
        </Avatar>
      </Stack>
    
    </CardContent>
  </Card>
  )
}

export default TotalProduced

TotalProduced.propTypes = {
  beginningDate : Proptypes.string,
  value: Proptypes.number
}

