// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

//image raw link -  https://raw.githubusercontent.com/cemmanuelonyema/cryptodevs-nft/master/my-app/public/cryptodevs/0.svg
//base URl  + tokenID
//base URl =  https://cryptodevsnft.vercel.app/api/
//Token id = 1

export default function handler(req, res) {
  const tokenId = req.query.tokenId;

  const name = `Crypto Dev #${tokenId}`;
  const description = "CryptoDevs is an Nft Collection for web 3 Developers";
  const image = ` https://raw.githubusercontent.com/cemmanuelonyema/cryptodevs-nft/master/my-app/public/cryptodevs/${
    Number(tokenId) - 1
  }.svg`;

  return res.json({
    name: name,
    description: description,
    image: image,
  });
}
