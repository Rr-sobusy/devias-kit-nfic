import React from 'react'
import { Avatar, Card, CardContent, Stack, SvgIcon, Typography } from "@mui/material";
import HomeICon from "@heroicons/react/24/solid/HomeIcon";
const TotalProduced = () => {
  return (
    <Card>
    <CardContent>
      <Stack spacing={3} direction="row" justifyContent="space-between">
        <Stack spacing={2}>
    
            <Typography color="text.secondary" variant="overline">
              Products produced
            </Typography>            
            <Typography variant="h4">
           100000 T
            </Typography>
            <Typography variant='caption' color="text.secondary">Since 03/23/2023</Typography>
        </Stack>
        <Avatar sx={{ bgcolor: "#F0DE36", height: 56, width: 56 }}>
          <SvgIcon>
            <HomeICon />
          </SvgIcon>
        </Avatar>
      </Stack>
    
    </CardContent>
  </Card>
  )
}

export default TotalProduced