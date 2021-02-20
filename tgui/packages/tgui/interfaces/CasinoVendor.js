import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

export const CasinoVendor = (props, context) => {
  const { act, data } = useBackend(context);
  let inventory = [
    ...data.product_records,
  ];
  return (
    <Window
      width={425}
      height={600}
      resizable>
      <Window.Content scrollable>
        <Section title="User">
          {data.user && (
            <Box>
              Your balance is <b>{data.user.points} credits</b>.
            </Box>
          ) || (
            <Box color="light-gray">
              A Tournament ID card is required to vend chips.<br />
              Please see the front desk.
            </Box>
          )}
        </Section>
        <Section title="Equipment">
          <Table>
            {inventory.map((product => {
              return (
                <Table.Row key={product.name}>
                  <Table.Cell>
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                      }} />
                    {' '}<b>{product.name}</b>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{
                        'min-width': '95px',
                        'text-align': 'center',
                      }}
                      disabled={!data.user
                        || product.price > data.user.points}
                      content={product.price + ' points'}
                      onClick={() => act('purchase', {
                        'ref': product.ref,
                      })} />
                  </Table.Cell>
                </Table.Row>
              );
            }))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
